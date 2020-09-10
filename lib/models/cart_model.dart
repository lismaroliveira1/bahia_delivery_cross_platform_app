import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];
  String couponCode;
  int discountPercentage = 0;
  bool isLoading = false;
  bool itemExist = false;
  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) async {
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

  Future<String> finishOrder() async {
    if (products.length == 0) return null;
    isLoading = true;
    notifyListeners();
    double productPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discountPrice = getDiscountPrice();
    DocumentReference referOrder =
        await Firestore.instance.collection("orders").add({
      "clients": user.firebaseUser.uid,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "discount": discountPrice,
      "totalPrice": productPrice - discountPrice + shipPrice,
      "status": 1
    });
    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("orders")
        .document(referOrder.documentID)
        .setData({"orderId": referOrder.documentID});
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();
    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }
    products.clear();
    couponCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();
    return referOrder.documentID;
  }
}
