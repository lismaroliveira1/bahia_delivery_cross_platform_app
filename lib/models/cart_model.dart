import 'dart:collection';
import 'dart:io';

import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/data/credit_debit_card_data.dart';
import 'package:bahia_delivery/data/incremental_only_choose.dart';
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
  bool itemExist = true;
  bool isSameStore = false;
  String currentStore = '';
  int quantity = 1;
  List<IncrementalOptData> productOptionals = [];
  List<IncrementalOnlyChooseData> optionalsOnlyChooseList = [];
  IncrementalOnlyChooseData incrementalOnlyChooseData;
  List<IncrementalOptData> itens = [];
  double complementPrice = 0;
  bool isAddingItemCart = false;
  bool hasProductInCart = true;
  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);
  @override
  void addListener(VoidCallback listener) {
    if (user.isLoggedIn()) _loadCartItems();
    super.addListener(listener);
    veryIfExistsProducts();
  }

  void addCartItem({
    @required CartProduct cartProduct,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required VoidCallback onDifferentStore,
  }) async {
    isAddingItemCart = true;
    notifyListeners();
    if (products.length == 0) {
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
        onSuccess();
        hasProductInCart = true;
        isAddingItemCart = false;
        notifyListeners();
      } catch (e) {
        print(e);
        isAddingItemCart = false;
        onFail();
        notifyListeners();
      }
    } else {
      for (var i = 0; i < products.length; i++) {
        if (products[i].storeId == cartProduct.storeId) {
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
            onSuccess();
            hasProductInCart = true;
            isAddingItemCart = false;
            isLoading = false;
            notifyListeners();
            break;
          } catch (e) {
            print(e);
            isAddingItemCart = false;
            isSameStore = false;
            onFail();
            notifyListeners();
            break;
          }
        } else {
          onDifferentStore();
          break;
        }
      }
    }
    isSameStore = false;
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
    cartProduct.price = cartProduct.quantify * cartProduct.productPrice;
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(cartProduct.cId)
        .updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    double priceOptinals = 0;

    for (IncrementalOptData incrementalOptData
        in cartProduct.productOptionals) {
      priceOptinals += incrementalOptData.price * incrementalOptData.quantity;
    }
    cartProduct.quantify++;
    cartProduct.price =
        cartProduct.quantify * (cartProduct.productPrice + priceOptinals);
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
    double priceOptionals = 0.0;
    for (CartProduct c in products) {
      for (var i = 0; i < c.productOptionals.length; i++) {
        priceOptionals +=
            c.productOptionals[i].quantity * c.productOptionals[i].price;
      }
      price += c.quantify * c.productPrice;
    }
    return price + priceOptionals;
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

  Future<void> finishOrderWithPayOnDelivery({
    @required VoidCallback onSucces,
  }) async {
    if (products.length == 0) return null;
    isLoading = true;
    notifyListeners();
    try {
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
        "clientImage": user.firebaseUser.photoUrl == null
            ? user.userImage
            : user.firebaseUser.photoUrl,
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
      onSucces();
    } catch (e) {
      print(e);
    }

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
    optionalsOnlyChooseList.clear();
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
  }

  void clearCartProduct() async {
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();
    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }
    products.clear();
  }

  void getOnlyChooseOptionals(
    DocumentSnapshot documentSnapshot,
    String storeId,
  ) async {
    try {
      optionalsOnlyChooseList.clear();
      itens.clear();
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection("stores")
          .document(storeId)
          .collection("products")
          .document(documentSnapshot.documentID)
          .collection("onlyChooseOptions")
          .getDocuments();

      for (DocumentSnapshot doc in querySnapshot.documents) {
        QuerySnapshot query = await Firestore.instance
            .collection("stores")
            .document(storeId)
            .collection("products")
            .document(documentSnapshot.documentID)
            .collection("onlyChooseOptions")
            .document(doc.documentID)
            .collection("itens")
            .getDocuments();

        query.documents.map((itemDoc) {
          itens.add(IncrementalOptData.fromDocument(itemDoc));
        }).toList();
        var incrementalOnlyChooseData = IncrementalOnlyChooseData.getAll(
          doc.data["id"],
          doc.data["secao"],
          itens,
        );
        print(incrementalOnlyChooseData.secao);
        optionalsOnlyChooseList.add(
          incrementalOnlyChooseData,
        );
      }

      notifyListeners();
    } catch (e) {}
  }

  void veryIfExistsProducts() async {
    bool isReady = false;
    if (!isReady) {
      try {
        products.clear();
        QuerySnapshot querySnapshot = await Firestore.instance
            .collection("users")
            .document(user.firebaseUser.uid)
            .collection("cart")
            .getDocuments();
        querySnapshot.documents.map((doc) {
          products.add(CartProduct.fromDocument(doc));
        }).toList();
      } catch (e) {}
      isReady = true;
    }
    notifyListeners();
  }
}
