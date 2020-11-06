import 'dart:collection';
import 'dart:io';

import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/data/credit_debit_card_data.dart';
import 'package:bahia_delivery/data/incremental_optional_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:random_string/random_string.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];
  String couponCode;
  Map<String, dynamic> dataSale = {};
  int discountPercentage = 0;
  bool isLoading = false;
  bool itemExist = false;
  String currentStore = '';
  int quantity = 1;
  List<IncrementalOptData> productOptionals = [];
  double complementPrice = 0;

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem({
    @required CartProduct cartProduct,
    @required VoidCallback onFail,
  }) async {
    try {
      products.add(cartProduct);
      Firestore.instance
          .collection("users")
          .document(user.firebaseUser.uid)
          .collection("cart")
          .add(cartProduct.toMap())
          .then((doc) {
        cartProduct.cId = doc.documentID;
      });
      notifyListeners();
    } catch (e) {
      print(e);
      onFail();
    }
  }

  void verifyItemCart(CartProduct cartProduct) async {
    for (CartProduct product in products) {
      if (product.pId == cartProduct.pId) {
        itemExist = true;
        break;
      } else {
        itemExist = false;
      }
    }
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cId)
        .delete();
    products.remove(cartProduct);
    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantify--;
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cId)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantify++;
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cId)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();
    products =
        query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) price += c.quantify * c.productData.price;
    }
    return price;
  }

  double getDiscountPrice() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  void updatePrices() {
    notifyListeners();
  }

  Future<String> finishOrder(CreditDebitCardData creditDebitCardData) async {
    final CloudFunctions functions = CloudFunctions.instance;
    if (products.length == 0) return null;
    isLoading = true;
    notifyListeners();
    double productPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discountPrice = getDiscountPrice();
    double totalPrice = productPrice - discountPrice + shipPrice;
    print(creditDebitCardData.cardNumber.replaceAll(" ", ""));
    print((totalPrice * 100).toInt());
    try {
      dataSale = {
        'merchantOrderId': randomAlphaNumeric(10),
        'amount': (totalPrice * 100).toInt(),
        'sotfDescriptor': "Bahia Delivery",
        'installments': 1,
        'creditCard': {
          'cardNumber': creditDebitCardData.cardNumber.replaceAll(" ", ""),
          'holder': creditDebitCardData.cardOwnerName,
          'expirationDate': creditDebitCardData.validateDate,
          'secuityCode': creditDebitCardData.cvv,
          'brand': creditDebitCardData.brand,
        },
        'cpf': creditDebitCardData.cpf,
        'paymentType': 'CreditCard'
      };

      final HttpsCallable callable =
          functions.getHttpsCallable(functionName: 'authorizedCreditCard');
      final response = await callable.call(dataSale);
      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
      if (data['success'] as bool) {
        QuerySnapshot query = await Firestore.instance
            .collection("users")
            .document(user.firebaseUser.uid)
            .collection("cart")
            .getDocuments();
        for (DocumentSnapshot doc in query.documents) {
          doc.reference.delete();
        }
        await Firestore.instance.collection("orders").add({
          "clients": user.firebaseUser.uid,
          "storeId": currentStore,
          "products":
              products.map((cartProduct) => cartProduct.toMap()).toList(),
          "shipPrice": shipPrice,
          "discount": discountPrice,
          "totalPrice": totalPrice,
          "status": 1,
          'createdAt': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem
        });
        products.clear();

        couponCode = null;
        isLoading = false;
        notifyListeners();
        return data['paymentId'] as String;
      } else {
        isLoading = false;
        notifyListeners();
        return Future.error(data['error']['message']);
      }
    } catch (e) {
      debugPrint('$e');
      isLoading = false;
      notifyListeners();
      return Future.error('Fala ao processa a transação. Tente Novamente');
    }
  }

  Future<void> finishOrderWithPayOnDelivery() async {
    if (products.length == 0) return null;
    isLoading = true;
    notifyListeners();
    double productPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discountPrice = getDiscountPrice();
    double totalPrice = productPrice - discountPrice + shipPrice;
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();
    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }
    DocumentSnapshot documentSnapshotStore = await Firestore.instance
        .collection("stores")
        .document(products[0].storeId)
        .get();
    DocumentSnapshot documentSnapshotUser = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .get();
    await Firestore.instance.collection("orders").add({
      "client": user.firebaseUser.uid,
      "clientName": documentSnapshotUser.data["name"],
      "clientImage": user.firebaseUser.photoUrl,
      "clientAddress": user.currentAddressDataFromGoogle.description
          .replaceAll("State of ", "")
          .replaceAll("Brazil", "Brasil"),
      "storeId": products[0].storeId,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "StoreName": documentSnapshotStore.data["name"],
      "storeImage": documentSnapshotStore.data["image"],
      "storeDescription": "storeDescrition",
      "discount": discountPrice,
      "totalPrice": totalPrice,
      "status": 1,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
      'paymentType': "Pagamento na Entrega"
    }).then((value) {});
    products.clear();
    couponCode = null;
    isLoading = false;
    notifyListeners();
  }

  void verifyCurrentStore({
    @required String storeId,
    @required VoidCallback onSameStore,
    @required VoidCallback onDifrentStore,
  }) {
    print("ok");
    if (currentStore == '') {
      print("same");
      currentStore = storeId;
      onSameStore();
    } else {
      if (currentStore == storeId) {
        onSameStore();
        print("same");
      } else {
        onDifrentStore();
      }
    }
  }

  void setQuantity(int productQuantitt) {
    quantity = productQuantitt;
    notifyListeners();
  }

  Future<void> listOptionals(
      DocumentSnapshot documentSnapshot, String storeId) async {
    productOptionals.clear();
    try {
      QuerySnapshot query = await Firestore.instance
          .collection("stores")
          .document(storeId)
          .collection("products")
          .document(documentSnapshot.documentID)
          .collection("incrementalOptions")
          .getDocuments();

      query.documents.map(
        (doc) {
          productOptionals.add(IncrementalOptData.fromDocument(doc));
        },
      ).toList();
      notifyListeners();
    } catch (erro) {
      print(erro);
      notifyListeners();
    }
  }

  void incrementComplement({
    @required IncrementalOptData incrementalOptData,
    @required VoidCallback onFail,
  }) {
    for (var i = 0; i < productOptionals.length; i++) {
      if (productOptionals[i].id == incrementalOptData.id) {
        productOptionals[i].quantity++;
        computeComplimentPrice();
        notifyListeners();
      }
    }
  }

  void decrementComplement(IncrementalOptData incrementalOptData) {
    for (var i = 0; i < productOptionals.length; i++) {
      if (productOptionals[i].id == incrementalOptData.id) {
        productOptionals[i].quantity--;
        computeComplimentPrice();
        notifyListeners();
      } else {}
    }
  }

  void computeComplimentPrice() {
    complementPrice = 0;
    for (var i = 0; i < productOptionals.length; i++) {
      complementPrice +=
          (productOptionals[i].price * productOptionals[i].quantity);
    }
    print(complementPrice.toString());
  }
}
