import 'dart:collection';
import 'dart:io';

import 'package:bd_app_full/data/address_data.dart';
import 'package:bd_app_full/data/cart_product.dart';
import 'package:bd_app_full/data/category_data.dart';
import 'package:bd_app_full/data/category_store_data.dart';
import 'package:bd_app_full/data/combo_data.dart';
import 'package:bd_app_full/data/credit_debit_card_Item.dart';
import 'package:bd_app_full/data/credit_debit_card_data.dart';
import 'package:bd_app_full/data/incremental_options_data.dart';
import 'package:bd_app_full/data/offs_data.dart';
import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/data/payment_form_data.dart';
import 'package:bd_app_full/data/payment_on_delivery_date.dart';
import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/data/subsection_data.dart';
import 'package:bd_app_full/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:random_string/random_string.dart';
import 'package:scoped_model/scoped_model.dart';

const token = '635289558f18ba4c749d6928e8cd0ba7';

class UserModel extends Model {
  bool isLoading = false;
  bool isReady = true;
  User firebaseUser;
  UserData userData;
  List<CategoryData> categoryList = [];
  List<OrderData> listUserOrders = [];
  List<StoreData> storeHomeList = [];
  List<StoreData> lastPurchasedStores = [];
  List<String> favoriteStoreId = [];
  List<StoreData> favoriteStoresList = [];
  List<ProductData> allProductsFromStoreHomeList = [];
  List<ProductData> productsPartnerList = [];
  List<CategoryStoreData> sectionsStorePartnerList = [];
  List<OffData> offPartnerData = [];
  List<ComboData> comboStoreList = [];
  List<ComboData> comboStoreHomeList = [];
  List<OrderData> partnerOrderList = [];
  List<CartProduct> cartProducts = [];
  String couponCode;
  int discountPercentage = 0;
  bool addressSeted = false;
  bool paymentSet = false;
  bool payOnApp = false;
  CreditDebitCardData currentCreditDebitCardData;
  PaymentOnDeliveryData currentPaymentOndeliveryData;
  Map<String, dynamic> dataSale = {};
  String userImage;
  bool hasProductInCart = false;
  List<CreditDebitCardData> creditDebitCardList = [];
  List<PaymentFormData> paymentFormsList = [];
  List<ComboData> comboCartList = [];

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Geodesy geodesy = Geodesy();

  FirebaseAuth _auth = FirebaseAuth.instance;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) async {
    super.addListener(listener);
    _loadCurrentUser();
    getPurchasedStoresList();
  }

  bool isLoggedIn() {
    return firebaseUser != null; //firebaseUser != null;
  }

  void _loadCurrentUser() async {
    isLoading = true;
    notifyListeners();
    if (firebaseUser == null) {
      firebaseUser = _auth.currentUser;
    }
    DocumentSnapshot docUser = await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .get();
    userData = UserData(
      name: docUser.get("name"),
      image: docUser.get("image"),
      email: firebaseUser.email,
      isPartner: docUser.get("isPartner"),
      storeId: docUser.get("isPartner") == 1 ? docUser.get("storeId") : "",
    );
    await getListOfCategory();
    await getListHomeStores();
    await getOrders();
    getcartProductList();
    getComboCartItens();
    getPaymentUserForms();
    await updateFavoritList();
    await getPartnerData();
    await getProductsPartnerList();
    await getSectionList();
    await getPartnerOffSales();
    await getComboList();
    await getPartnerOrderList();
    getPurchasedStoresList();
    getAllProductsToList();
    getPaymentUserForms();
    isLoading = false;
    isReady = true;

    notifyListeners();
  }

  Future<void> signUpWithGoogle({
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required VoidCallback onFailGoogle,
  }) async {
    try {
      bool hasPartnerInDataBank = false;
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return null;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      this.firebaseUser = authResult.user;
      QuerySnapshot queryUser =
          await FirebaseFirestore.instance.collection("users").get();
      List<QueryDocumentSnapshot> list = queryUser.docs;
      for (QueryDocumentSnapshot doc in list) {
        if (doc.id == firebaseUser.uid) {
          hasPartnerInDataBank = true;
          break;
        }
      }
      if (!hasPartnerInDataBank) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .set({
          "email": firebaseUser.email,
          "image": firebaseUser.photoURL,
          "isPartner": 3,
          "name": firebaseUser.displayName,
          "phoneNumber": firebaseUser.phoneNumber,
        });
        saveToken();
        _loadCurrentUser();
        onSuccess();
        notifyListeners();
      } else {
        onFailGoogle();
      }
    } catch (erro) {
      onFail();
    }
  }

  Future<void> signUp({
    @required UserData user,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    try {
      print(user.email);
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      this.firebaseUser = result.user;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .set({
        "email": user.email,
        "image": "https://meuvidraceiro.com.br/images/sem-imagem.png",
        "isPartner": 3,
        "name": user.name,
        "phoneNumber": "",
      });
      saveToken();
      _loadCurrentUser();
      onSuccess();
      notifyListeners();
    } catch (error) {
      print(error);
      onFail();
    }
  }

  Future<void> signUpWithFacebook({
    @required VoidCallback onSuccess,
    @required onFail,
    @required onFailFacebook,
  }) async {}

  void signIn({
    @required String email,
    @required String pass,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      this.firebaseUser = result.user;
      saveToken();
      _loadCurrentUser();
      notifyListeners();
    } catch (erro) {}
  }

  void signOut({
    @required VoidCallback onSuccess,
  }) async {
    isLoading = true;
    notifyListeners();
    await _auth.signOut();
    firebaseUser = null;
    onSuccess();
    notifyListeners();
    firebaseUser = null;
    categoryList = [];
    listUserOrders = [];
    storeHomeList = [];
    lastPurchasedStores = [];
    favoriteStoreId = [];
    favoriteStoresList = [];
    allProductsFromStoreHomeList = [];
    productsPartnerList = [];
    sectionsStorePartnerList = [];
    offPartnerData = [];
    comboStoreList = [];
    comboStoreHomeList = [];
    partnerOrderList = [];
    cartProducts = [];
    dataSale = {};
    creditDebitCardList = [];
    paymentFormsList = [];
    isLoading = false;
  }

  void signInWithGoogle({
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return null;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      this.firebaseUser = authResult.user;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .update({
        "phoneNumber": firebaseUser.phoneNumber,
        "image": firebaseUser.photoURL,
      });
      saveToken();
      _loadCurrentUser();
      notifyListeners();
    } catch (erro) {
      print(erro);
    }
    notifyListeners();
  }

  void signInWithFacebook({
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) {}

  Future<void> getListOfCategory() async {
    try {
      QuerySnapshot querySnashot =
          await FirebaseFirestore.instance.collection("categories").get();
      querySnashot.docs
          .map((queryDoc) =>
              categoryList.add(CategoryData.fromQueryDocument(queryDoc)))
          .toList();
      notifyListeners();
    } catch (erro) {
      sendErrorMessageToADM(
        errorFromUser: erro.toString(),
      );
    }
  }

  void sendErrorMessageToADM({@required String errorFromUser}) async {
    try {
      await FirebaseFirestore.instance.collection("errors").add({
        "erro": errorFromUser,
        "userId": firebaseUser.uid,
        "errorAt": DateTime.now(),
      });
    } catch (error) {}
  }

  Future<void> getOrders() async {
    if (isLoggedIn()) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("orders")
            .orderBy(
              "createdAt",
              descending: true,
            )
            .get();
        querySnapshot.docs.map((queryDoc) async {
          if (queryDoc.get("client") == firebaseUser.uid) {
            listUserOrders.add(OrderData.fromQueryDocument(queryDoc));
          }
        }).toList();
        notifyListeners();
      } catch (erro) {
        sendErrorMessageToADM(
          errorFromUser: erro.toString(),
        );
        notifyListeners();
      }
    }
  }

  Future<void> getListHomeStores() async {
    if (isLoggedIn()) {
      storeHomeList.clear();
      _locationData = await location.getLocation();
      LatLng latLngDevice = LatLng(
        _locationData.latitude,
        _locationData.longitude,
      );
      try {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection("stores").get();
        querySnapshot.docs.map((queryDoc) {
          storeHomeList.add(StoreData.fromQueryDocument(queryDoc));
        }).toList();
        storeHomeList.forEach((storeElement) async {
          List<ProductData> purchasedProducts = [];

          storeElement.productsOff = await getOffStores(storeElement.id);
          storeElement.products = await getProductsStore(storeElement.id);
          storeElement.storesCombos =
              await getComboStoreHomeList(storeElement.id);

          storeElement.products.forEach((element) async {
            element.incrementalOptionalsList = await getIncrementalByProduct(
                storeId: storeElement.id, productId: element.pId);
          });
          storeElement.storeCategoryList =
              await getCategoryByStore(storeElement.id);
          for (OrderData orderData in listUserOrders) {
            for (ProductData productData in orderData.products) {
              for (ProductData productDataStore in storeElement.products) {
                if (productDataStore.pId == productData.pId) {
                  if (purchasedProducts.length == 0) {
                    purchasedProducts.add(productDataStore);
                  } else {
                    bool hasThisProduct = false;
                    for (ProductData purchasedProductElement
                        in purchasedProducts) {
                      if (productDataStore.pId == purchasedProductElement.pId) {
                        hasThisProduct = true;
                        break;
                      }
                    }
                    if (!hasThisProduct)
                      purchasedProducts.add(productDataStore);
                  }
                }
              }
            }
          }
          storeElement.purchasedProducts = purchasedProducts;
          storeElement.distance = geodesy.distanceBetweenTwoGeoPoints(
            storeElement.latLng,
            latLngDevice,
          );
          storeElement.deliveryTime = calctime(storeElement.distance);
        });
      } catch (erro) {
        sendErrorMessageToADM(
          errorFromUser: erro.toString(),
        );
        notifyListeners();
      }
    }
  }

  double calctime(double distance) {
    double storeTime;
    double averageSpeed = 15;
    storeTime = distance / (averageSpeed * 60);
    return storeTime;
  }

  Future<List<IncrementalOptionalsData>> getIncrementalByProduct({
    @required storeId,
    @required productId,
  }) async {
    List<IncrementalOptionalsData> incrementals = [];
    if (isLoggedIn()) {
      try {
        QuerySnapshot query = await FirebaseFirestore.instance
            .collection("stores")
            .doc(storeId)
            .collection("products")
            .doc(productId)
            .collection("incrementalOptions")
            .get();
        query.docs.map((doc) {
          incrementals.add(IncrementalOptionalsData.fromQueryDocument(doc));
        }).toList();

        notifyListeners();
        return incrementals;
      } catch (erro) {
        notifyListeners();
        return [];
      }
    } else {
      notifyListeners();
      return [];
    }
  }

  Future<List<OffData>> getOffStores(String id) async {
    if (isLoggedIn()) {
      final List<OffData> productsOff = [];
      QuerySnapshot offs = await FirebaseFirestore.instance
          .collection("stores")
          .doc(id)
          .collection("off")
          .get();
      offs.docs.map((queryDoc) {
        productsOff.add(OffData.fromQueryDocument(queryDoc));
      }).toList();
      return productsOff;
    } else {
      return [];
    }
  }

  Future<List<ProductData>> getProductsStore(String id) async {
    if (isLoggedIn()) {
      List<ProductData> products = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("stores")
          .doc(id)
          .collection("products")
          .get();
      querySnapshot.docs.map((queryDoc) {
        products.add(ProductData.fromQueryDocument(queryDoc));
      }).toList();

      return products;
    } else {
      return [];
    }
  }

  Future<List<CategoryStoreData>> getCategoryByStore(String id) async {
    if (isLoggedIn()) {
      List<CategoryStoreData> storeCategoryList = [];
      QuerySnapshot queryCategory = await FirebaseFirestore.instance
          .collection("stores")
          .doc(id)
          .collection("categories")
          .orderBy(
            "order",
            descending: false,
          )
          .get();
      queryCategory.docs.map((storeCategory) {
        storeCategoryList
            .add(CategoryStoreData.fromQueryDocument(storeCategory));
      }).toList();
      return storeCategoryList;
    } else {
      return [];
    }
  }

  void getPurchasedStoresList() {
    if (isLoggedIn()) {
      lastPurchasedStores.clear();
      for (OrderData ordeData in listUserOrders) {
        for (StoreData storeData in storeHomeList) {
          if (ordeData.storeId == storeData.id) {
            if (lastPurchasedStores.length == 0) {
              lastPurchasedStores.add(storeData);
            } else {
              bool hasStore = false;
              for (StoreData storePurchasedData in lastPurchasedStores) {
                if (storePurchasedData.id == storeData.id) {
                  hasStore = true;
                  break;
                }
              }
              if (!hasStore) {
                lastPurchasedStores.add(storeData);
              }
            }
          }
        }
      }
      notifyListeners();
    }
  }

  void addRemoveStoreFavorite({
    @required storeId,
  }) async {
    if (isLoggedIn()) {
      for (StoreData storeData in storeHomeList) {
        if (storeData.id == storeId) {
          if (storeData.isFavorite) {
            storeData.isFavorite = false;
            favoriteStoresList.remove(storeData);
            notifyListeners();
            QuerySnapshot queryDoc = await FirebaseFirestore.instance
                .collection("users")
                .doc(firebaseUser.uid)
                .collection("favorites")
                .get();

            for (QueryDocumentSnapshot queryDocumentSnapshot in queryDoc.docs) {
              if (queryDocumentSnapshot.get("storeId") == storeId) {
                queryDocumentSnapshot.reference.delete();
                break;
              }
            }
            break;
          } else {
            favoriteStoresList.add(storeData);
            storeData.isFavorite = true;
            notifyListeners();
            await FirebaseFirestore.instance
                .collection("users")
                .doc(firebaseUser.uid)
                .collection("favorites")
                .add({
              "storeId": storeId,
            });

            break;
          }
        }
      }
      notifyListeners();
    }
  }

  Future<void> updateFavoritList() async {
    if (isLoggedIn()) {
      favoriteStoresList.clear();
      favoriteStoreId.clear();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("favorites")
          .get();
      querySnapshot.docs.map((queryDoc) {
        favoriteStoreId.add(queryDoc.get("storeId"));
      }).toList();
      for (StoreData storeDataFavorite in storeHomeList) {
        for (String storeFavoriteId in favoriteStoreId) {
          if (storeFavoriteId == storeDataFavorite.id) {
            storeDataFavorite.isFavorite = true;
            favoriteStoresList.add(storeDataFavorite);
            break;
          }
        }
      }
      notifyListeners();
    }
  }

  void getAllProductsToList() {
    allProductsFromStoreHomeList.clear();
    if (isLoggedIn()) {
      for (StoreData storeData in storeHomeList) {
        for (ProductData productsFromStore in storeData.products) {
          allProductsFromStoreHomeList.add(productsFromStore);
        }
      }
      notifyListeners();
    }
  }

  Future<void> getPartnerData() async {
    if (isLoggedIn()) {
      DocumentSnapshot docUserSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .get();
      userData.isPartner = docUserSnapshot.get("isPartner");
      if (docUserSnapshot.get("isPartner") == 1) {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection("stores")
            .doc(docUserSnapshot.get("storeId"))
            .get();
        userData.storeId = docSnapshot.id;
        userData.storeName = docSnapshot.get("title");
        userData.storeImage = docSnapshot.get("image");
      }
      notifyListeners();
    }
  }

  Future<void> getProductsPartnerList() async {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        productsPartnerList.clear();
        try {
          QuerySnapshot queryProductsSnapshot = await FirebaseFirestore.instance
              .collection("stores")
              .doc(userData.storeId)
              .collection("products")
              .get();
          queryProductsSnapshot.docs.map((queryDoc) {
            productsPartnerList.add(ProductData.fromQueryDocument(queryDoc));
          }).toList();
        } catch (erro) {}
      }
    }
  }

  Future<void> getSectionList() async {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("stores")
            .doc(userData.storeId)
            .collection("categories")
            .orderBy(
              "order",
              descending: false,
            )
            .get();
        sectionsStorePartnerList.clear();
        querySnapshot.docs.map((queryDoc) {
          sectionsStorePartnerList
              .add(CategoryStoreData.fromQueryDocument(queryDoc));
        }).toList();
        sectionsStorePartnerList.forEach((section) async {
          List<SubSectionData> subsectionList = [];
          QuerySnapshot querySubSection = await FirebaseFirestore.instance
              .collection("stores")
              .doc(userData.storeId)
              .collection("categories")
              .doc(section.id)
              .collection("subcategories")
              .orderBy(
                "order",
                descending: false,
              )
              .get();
          querySubSection.docs.map((queryDoc) {
            subsectionList
                .add(SubSectionData.fromQuerDocument(queryDoc, section.id));
          }).toList();
          section.subSectionsList = subsectionList;
        });
        notifyListeners();
      }
    }
  }

  void editNewSection({
    @required String sectionId,
    @required String title,
    @required String description,
    @required int order,
    @required int x,
    @required int y,
    @required imageUrl,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required File imageFile,
    @required int olderPos,
  }) async {
    if (isLoggedIn()) {
      List<CategoryStoreData> sectionStoreListFlag = sectionsStorePartnerList;
      isLoading = true;
      print(olderPos);
      notifyListeners();
      if (userData.isPartner == 1) {
        String url = imageUrl;
        try {
          if (imageFile == null) {
            url = imageUrl;
            for (var i = 0; i < order - 1; i++) {
              sectionStoreListFlag[i] = sectionsStorePartnerList[i];
              sectionStoreListFlag[i].order = i;
              print(sectionStoreListFlag[i].title);
              print(sectionStoreListFlag[i].order);
            }

            sectionStoreListFlag[order - 1] =
                sectionsStorePartnerList[olderPos];
            sectionStoreListFlag[order - 1].order = order - 1;
            print(sectionStoreListFlag[order - 1].title);
            print(sectionStoreListFlag[order - 1].order);

            for (var i = 0; i < sectionsStorePartnerList.length; i++) {
              if (sectionsStorePartnerList[i].id == sectionId) {
                sectionsStorePartnerList.remove(sectionsStorePartnerList[i]);
                break;
              }
            }
            for (var i = order - 1; i < sectionsStorePartnerList.length; i++) {
              if (sectionsStorePartnerList[i].id != sectionId) {
                sectionStoreListFlag[i] = sectionsStorePartnerList[i];
                sectionStoreListFlag[i].order = i + 1;
                print(sectionStoreListFlag[i].title);
                print(sectionStoreListFlag[i].order);
              }
            }
            sectionStoreListFlag.forEach((element) async {
              await FirebaseFirestore.instance
                  .collection("stores")
                  .doc(userData.storeId)
                  .collection("categories")
                  .doc(sectionId)
                  .update({
                "title": element.title,
                "description": element.description,
                "order": element.order,
                "x": element.x,
                "y": element.y,
                "image": element.image,
              });
            });
            await getSectionList();
            isLoading = false;
            onSuccess();
            notifyListeners();
          } else {
            isLoading = true;
            notifyListeners();
            Reference ref =
                FirebaseStorage.instance.ref().child("images").child(
                      DateTime.now().millisecond.toString(),
                    );
            UploadTask uploadTask = ref.putFile(imageFile);
            uploadTask.then((value) async {
              url = await value.ref.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection("stores")
                  .doc(userData.storeId)
                  .collection("categories")
                  .doc(sectionId)
                  .update({
                "title": title,
                "description": description,
                "order": order - 1,
                "x": x,
                "y": y,
                "image": url,
              });
              await getSectionList();
              isLoading = false;
              onSuccess();
              notifyListeners();
            });
          }
        } catch (erro) {
          print(erro);
          isLoading = false;
          onFail();
          notifyListeners();
        }
      }
    }
  }

  void insertNewSubsection({
    @required SubSectionData subSectionData,
    @required VoidCallback onSucess,
    @required VoidCallback onFail,
  }) async {
    if (isLoggedIn()) {
      isLoading = true;
      notifyListeners();
      try {
        await FirebaseFirestore.instance
            .collection("stores")
            .doc(userData.storeId)
            .collection("categories")
            .doc(subSectionData.sectionId)
            .collection("subcategories")
            .add(
              subSectionData.toMap(),
            );
        sectionsStorePartnerList.forEach((section) async {
          List<SubSectionData> subsectionList = [];
          QuerySnapshot querySubSection = await FirebaseFirestore.instance
              .collection("stores")
              .doc(userData.storeId)
              .collection("categories")
              .doc(section.id)
              .collection("subcategories")
              .orderBy(
                "order",
                descending: false,
              )
              .get();
          querySubSection.docs.map((queryDoc) {
            subsectionList
                .add(SubSectionData.fromQuerDocument(queryDoc, section.id));
          }).toList();
          section.subSectionsList = subsectionList;
        });
        onSucess();
        isLoading = false;
        notifyListeners();
      } catch (erro) {
        isLoading = false;
        onFail();
        notifyListeners();
      }
    }
  }

  Future<void> getPartnerOffSales() async {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("stores")
            .doc(userData.storeId)
            .collection("off")
            .get();
        offPartnerData.clear();
        querySnapshot.docs.map((queryDoc) {
          offPartnerData.add(OffData.fromQueryDocument(queryDoc));
        }).toList();
        notifyListeners();
      }
    }
  }

  Future<void> insertNewCombo({
    @required ComboData comboData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required File imageFile,
  }) async {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        isLoading = true;
        notifyListeners();
        try {
          if (imageFile != null) {
            Reference ref =
                FirebaseStorage.instance.ref().child("images").child(
                      DateTime.now().millisecond.toString(),
                    );
            UploadTask uploadTask = ref.putFile(imageFile);
            uploadTask.then((value) async {
              comboData.image = await value.ref.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection("stores")
                  .doc(userData.storeId)
                  .collection("combos")
                  .add(
                    comboData.toMap(),
                  );
              isLoading = false;
              getComboList();
              onSuccess();
              notifyListeners();
            });
          } else {
            await FirebaseFirestore.instance
                .collection("stores")
                .doc(userData.storeId)
                .collection("combos")
                .add(
                  comboData.toMap(),
                );
            isLoading = false;
            getComboList();
            onSuccess();
            notifyListeners();
          }
        } catch (erro) {
          isLoading = false;
          onFail();
          notifyListeners();
        }
      }
    }
  }

  Future<void> getComboList() async {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("stores")
            .doc(userData.storeId)
            .collection("combos")
            .get();
        comboStoreList.clear();
        querySnapshot.docs.map((queryDoc) {
          comboStoreList.add(ComboData.fromQueryDocument(queryDoc));
        }).toList();
      }
      notifyListeners();
    }
  }

  Future<List<ComboData>> getComboStoreHomeList(String storeComboId) async {
    if (isLoggedIn()) {
      List<ComboData> combodata = [];
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("stores")
          .doc(storeComboId)
          .collection("combos")
          .get();
      querySnapshot.docs.map((queryDoc) {
        combodata.add(ComboData.fromQueryDocument(queryDoc));
      }).toList();
      return combodata;
    } else {
      return [];
    }
  }

  void editPartnerProduct({
    @required ProductData productData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required File imageFile,
  }) async {
    if (imageFile != null) {
      try {
        Reference ref = FirebaseStorage.instance.ref().child("images").child(
              DateTime.now().millisecond.toString(),
            );
        UploadTask uploadTask = ref.putFile(imageFile);
        uploadTask.then((value) async {
          productData.productImage = await value.ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection("stores")
              .doc(userData.storeId)
              .collection("products")
              .doc(productData.pId)
              .update(
                productData.toMap(),
              );
          await getProductsPartnerList();
          onSuccess();
          notifyListeners();
        });
      } catch (erro) {}
    } else {
      try {
        await FirebaseFirestore.instance
            .collection("stores")
            .doc(userData.storeId)
            .collection("products")
            .doc(productData.pId)
            .update(
              productData.toMap(),
            );
        await getProductsPartnerList();
        onSuccess();
        notifyListeners();
        getListHomeStores();
      } catch (erro) {
        onFail();
      }
    }
  }

  void insertNewProduct({
    @required ProductData productData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required File imageFile,
  }) async {
    if (imageFile != null) {
      try {
        Reference ref = FirebaseStorage.instance.ref().child("images").child(
              DateTime.now().millisecond.toString(),
            );
        UploadTask uploadTask = ref.putFile(imageFile);
        uploadTask.then((value) async {
          productData.productImage = await value.ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection("stores")
              .doc(userData.storeId)
              .collection("products")
              .add(
                productData.toMap(),
              );
          await getProductsPartnerList();
          onSuccess();
          notifyListeners();
        });
      } catch (erro) {}
    } else {
      try {
        await FirebaseFirestore.instance
            .collection("stores")
            .doc(userData.storeId)
            .collection("products")
            .add(
              productData.toMap(),
            );
        await getProductsPartnerList();
        onSuccess();
        notifyListeners();
        getListHomeStores();
      } catch (erro) {
        onFail();
      }
    }
  }

  Future<void> editPartnerCombo({
    @required ComboData comboData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required File imageFile,
  }) async {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        print("ok");
        isLoading = true;
        notifyListeners();
        try {
          print(comboData.id);
          if (imageFile != null) {
            Reference ref =
                FirebaseStorage.instance.ref().child("images").child(
                      DateTime.now().millisecond.toString(),
                    );
            UploadTask uploadTask = ref.putFile(imageFile);
            uploadTask.then((value) async {
              comboData.image = await value.ref.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection("stores")
                  .doc(userData.storeId)
                  .collection("combos")
                  .doc(comboData.id)
                  .update(
                    comboData.toMap(),
                  );
              isLoading = false;
              getComboList();
              onSuccess();
              notifyListeners();
            });
          } else {
            await FirebaseFirestore.instance
                .collection("stores")
                .doc(userData.storeId)
                .collection("combos")
                .doc(comboData.id)
                .update(
                  comboData.toMap(),
                );
            isLoading = false;
            getComboList();
            onSuccess();
            notifyListeners();
            getListHomeStores();
          }
        } catch (erro) {
          print(erro);
          isLoading = false;
          onFail();
          notifyListeners();
        }
      }
    }
  }

  void editSaleOff({
    @required OffData offData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    print(offData.id);
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        isLoading = true;
        notifyListeners();
        if (offData.imageFile != null) {
          try {
            Reference ref =
                FirebaseStorage.instance.ref().child("images").child(
                      DateTime.now().millisecond.toString(),
                    );
            UploadTask uploadTask = ref.putFile(offData.imageFile);
            uploadTask.then((task) async {
              offData.image = await task.ref.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection("stores")
                  .doc(userData.storeId)
                  .collection("off")
                  .doc(offData.id)
                  .update(
                    offData.toMap(),
                  );
              isLoading = false;
              getPartnerOffSales();
              onSuccess();
              notifyListeners();
            });
          } catch (erro) {
            onFail();
            notifyListeners();
          }
        } else {
          try {
            await FirebaseFirestore.instance
                .collection("stores")
                .doc(userData.storeId)
                .collection("off")
                .doc(offData.id)
                .update(
                  offData.toMap(),
                );
            isLoading = false;
            getPartnerOffSales();
            onSuccess();
            notifyListeners();
            getListHomeStores();
          } catch (errro) {
            onFail();
            notifyListeners();
          }
        }
      }
    }
  }

  void insertNewOffSale({
    @required OffData offData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    print(offData.id);
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        isLoading = true;
        notifyListeners();
        if (offData.imageFile != null) {
          try {
            Reference ref =
                FirebaseStorage.instance.ref().child("images").child(
                      DateTime.now().millisecond.toString(),
                    );
            UploadTask uploadTask = ref.putFile(offData.imageFile);
            uploadTask.then((task) async {
              offData.image = await task.ref.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection("stores")
                  .doc(userData.storeId)
                  .collection("off")
                  .add(
                    offData.toMap(),
                  );
              isLoading = false;
              getPartnerOffSales();
              onSuccess();
              notifyListeners();
              getListHomeStores();
            });
          } catch (erro) {
            onFail();
            notifyListeners();
          }
        } else {
          try {
            await FirebaseFirestore.instance
                .collection("stores")
                .doc(userData.storeId)
                .collection("off")
                .add(
                  offData.toMap(),
                );
            isLoading = false;
            getPartnerOffSales();
            onSuccess();
            notifyListeners();
            getListHomeStores();
          } catch (errro) {
            onFail();
            notifyListeners();
          }
        }
      }
    }
  }

  Future<void> getPartnerOrderList() async {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("orders")
            .orderBy(
              "createdAt",
              descending: true,
            )
            .get();
        querySnapshot.docs.map((queryDoc) {
          partnerOrderList.add(OrderData.fromQueryDocument(queryDoc));
        }).toList();
      }
    }
  }

  void addCartItem({
    @required CartProduct cartProduct,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    if (isLoggedIn()) {
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .collection("cart")
            .add(
              cartProduct.toMap(),
            );
        getcartProductList();
        onSuccess();
        notifyListeners();
      } catch (erro) {
        onFail();
        notifyListeners();
      }
    }
  }

  void getcartProductList() async {
    if (isLoggedIn()) {
      cartProducts.clear();
      QuerySnapshot cartQuery = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("cart")
          .get();
      cartQuery.docs.map((queryDoc) {
        if (queryDoc.get("type") == "product") {
          cartProducts.add(CartProduct.fromDocument(queryDoc));
        }
      }).toList();
      if (cartProducts.length > 0) {
        hasProductInCart = true;
      }
      notifyListeners();
    }
  }

  void removeCartItem({
    @required CartProduct cartProduct,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    if (isLoggedIn())
      try {
        FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .collection("cart")
            .doc(cartProduct.cId)
            .delete();
        cartProducts.remove(cartProduct);
        onSuccess();
        notifyListeners();
      } catch (erro) {
        onFail();
        notifyListeners();
      }
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantify--;
    cartProduct.price = cartProduct.quantify * cartProduct.productPrice;
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .collection("cart")
        .doc(cartProduct.cId)
        .update(
          cartProduct.toMap(),
        );
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    double priceOptinals = 0;

    for (IncrementalOptionalsData incrementalOptData
        in cartProduct.productOptionals) {
      priceOptinals += incrementalOptData.price * incrementalOptData.quantity;
    }
    cartProduct.quantify++;
    cartProduct.price =
        cartProduct.quantify * (cartProduct.productPrice + priceOptinals);
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .collection("cart")
        .doc(cartProduct.cId)
        .update(cartProduct.toMap());
    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void setCurrentCrediCard(CreditDebitCardData creditDebitCardData) {
    isLoading = true;
    notifyListeners();
    currentCreditDebitCardData = creditDebitCardData;
    paymentSet = true;
    payOnApp = true;
    isLoading = false;
    notifyListeners();
  }

  double getShipPrice() {
    return 9.99;
  }

  double getProductsPrice() {
    double price = 0.0;
    double priceOptionals = 0.0;
    for (CartProduct c in cartProducts) {
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

  Future<String> finishOrder({
    @required double discount,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required double shipePrice,
    @required StoreData storeData,
    @required CreditDebitCardData creditDebitCardData,
  }) async {
    if (isLoggedIn()) {
      double totalPrice = 0;
      final FirebaseFunctions functions = FirebaseFunctions.instance;
      try {
        if (cartProducts.length == 0) return null;
        print("ok");
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .collection("cart")
            .get();
        querySnapshot.docs.map((queryDoc) {
          totalPrice += queryDoc.get("totalPrice");
        }).toList();
        print(creditDebitCardData.cpf);

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
          'cpf':
              creditDebitCardData.cpf.replaceAll(".", "").replaceAll("-", ""),
          'paymentType': 'CreditCard'
        };
        final HttpsCallable callable =
            functions.httpsCallable('authorizedCreditCard');
        final response = await callable.call(dataSale);
        final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
        print(data["success"]);
        if (data["success"] as bool) {
          await FirebaseFirestore.instance.collection("orders").add({
            "client": firebaseUser.uid,
            "clientName": userData.name,
            "clientImage": firebaseUser.photoURL == null
                ? userImage
                : firebaseUser.photoURL,
            "clientAddress": "",
            /*currentAddressDataFromGoogle.description
                .replaceAll("State of ", "")
                .replaceAll("Brazil", "Brasil"),*/
            "storeId": storeData.id,
            "products":
                cartProducts.map((cartProduct) => cartProduct.toMap()).toList(),
            "shipPrice": shipePrice,
            "StoreName": storeData.name,
            "storeImage": storeData.image,
            "storeDescription": "storeDescrition",
            "discount": discount,
            "totalPrice": totalPrice,
            "status": 1,
            'createdAt': FieldValue.serverTimestamp(),
            'paymentType': "Pagamento na Entrega"
          });
          cartProducts.clear();
          hasProductInCart = false;
          onSuccess();
          notifyListeners();
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            doc.reference.delete();
          }
          await getListOfCategory();
          await getOrders();
          await getListHomeStores();
          getcartProductList();
          await updateFavoritList();
          return data['paymentId'] as String;
        } else {
          onFail();
          notifyListeners();
          return Future.error(data['error']['message']);
        }
      } catch (e) {
        notifyListeners();
        return Future.error('Fala ao processa a transação. Tente Novamente');
      }
    } else {
      return "";
    }
  }

  Future<void> finishOrderWithPayOnDelivery({
    @required double discount,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required double shipePrice,
    @required StoreData storeData,
  }) async {
    if (firebaseUser != null) {
      double totalPrice = 0;
      double productPrice = 0;
      double comboPrice = 0;
      double offPrice = 0;

      try {
        print(cartProducts.length);
        print("ok");
        if (cartProducts.length == 0 && comboCartList.length == 0) return null;
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .collection("cart")
            .get();
        List<QueryDocumentSnapshot> items = querySnapshot.docs;
        for (QueryDocumentSnapshot doc in items) {
          if (doc.get("type") == "products") {
            productPrice += doc.get("totalPrice");
          } else if (doc.get("type") == "combo") {
            comboPrice += doc.get("price");
          }
        }
        totalPrice = productPrice + comboPrice + offPrice;
        await FirebaseFirestore.instance.collection("orders").add({
          "client": firebaseUser.uid,
          "clientName": userData.name,
          "clientImage": userData.image,
          "clientAddress": "" //currentAddressDataFromGoogle.description
              .replaceAll("State of ", "")
              .replaceAll("Brazil", "Brasil"),
          "storeId": storeData.id,
          "products": cartProducts
              .map(
                (cartProduct) => cartProduct.toMap(),
              )
              .toList(),
          "combos": comboCartList
              .map(
                (combo) => combo.toComboProductMap(),
              )
              .toList(),
          "shipPrice": shipePrice,
          "StoreName": storeData.name,
          "storeImage": storeData.image,
          "storeDescription": "storeDescrition",
          "discount": discount,
          "totalPrice": totalPrice,
          "status": 1,
          'createdAt': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem,
          'paymentType': "Pagamento na Entrega"
        });
        cartProducts.clear();
        comboCartList.clear();
        hasProductInCart = false;
        onSuccess();
        notifyListeners();
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          doc.reference.delete();
        }
        await getListOfCategory();
        await getOrders();
        await getListHomeStores();
        getcartProductList();
        await updateFavoritList();
      } catch (e) {
        onFail();
        print(e);
      }
    }
  }

  void saveToken() async {
    final token = await FirebaseMessaging().getToken();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection("tokens")
        .doc(token)
        .set({
      'token': token,
      'updateAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem
    });
  }

  void setPaymentOnDeliveryMethod(PaymentOnDeliveryData paymentOnDeliveryData) {
    isLoading = true;
    notifyListeners();
    paymentSet = true;
    currentPaymentOndeliveryData = paymentOnDeliveryData;
    payOnApp = false;
    isLoading = false;
    notifyListeners();
  }

  void newCard(CreditDebitCard creditDebitCard) async {
    isLoading = true;
    notifyListeners();
    final creditDebitCardData =
        CreditDebitCardData.fromCreditDebitCardItem(creditDebitCard);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('paymentForms')
        .add({
      'cardNumber': creditDebitCard.cardNumber,
      'cardOwnerName': creditDebitCard.cardOwnerName,
      'validateDate': creditDebitCard.validateDate,
      'cpf': creditDebitCard.cpf,
      'cvv': creditDebitCard.cvv,
      'image': creditDebitCard.image,
      'type': 'creditDebitCard',
      'brand': creditDebitCard.brand
    }).then((doc) {
      if (doc.id != null) {
        creditDebitCardData.cardId = doc.id;
        creditDebitCardList.add(creditDebitCardData);
      } else {
        creditDebitCardData.cardId = "";
      }
    });
    isLoading = false;
    notifyListeners();
  }

  void getPaymentUserForms() async {
    if (isLoggedIn()) {
      paymentFormsList.clear();
      QuerySnapshot paymentQuery = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("paymentForms")
          .get();
      paymentQuery.docs.map((queryDoc) {
        paymentFormsList.add(
          PaymentFormData.fromQuerydocs(queryDoc),
        );
      }).toList();
      notifyListeners();
    }
  }

  Future<void> getLocationDevice() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    userData.latitude = _locationData.latitude;
    userData.longitude = _locationData.longitude;
    await getAddressFromLatLng(
      lat: _locationData.latitude,
      lng: _locationData.longitude,
    );
  }

  Future<void> getAddressFromLatLng(
      {@required double lat, @required double lng}) async {
    isLoading = true;
    notifyListeners();
    final endPoint = "https://www.cepaberto.com/api/v3/nearest";
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';
    try {
      final response = await dio.get<Map<String, dynamic>>(endPoint,
          queryParameters: {'lat': lat, 'lng': lng});
      if (response.data.isEmpty) {
        return Future.error('Dados Inválidos');
      }
      //final cepAbertoAddress = CepAbertoAddress.fromMap(response.data);
      /*if (cepAbertoAddress != null) {
        street = cepAbertoAddress.logradouro;
        state = cepAbertoAddress.state.sigla;
        zipCode = cepAbertoAddress.cep;
        district = cepAbertoAddress.bairro;
        city = cepAbertoAddress.city.nome;
      }*/
      if (response.data != null) {
        userData.userAdress = AdressData.fromResponse(response);
        userData.latLng = LatLng(
          userData.userAdress.latitude,
          userData.userAdress.longitude,
        );
      }
    } on DioError {}
    isLoading = false;
    notifyListeners();
  }

  void addComboToCart({
    @required ComboData comboData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    if (isLoggedIn()) {
      isLoading = true;
      notifyListeners();
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .collection("cart")
            .add(
              comboData.toComboProductMap(),
            );
        await getComboCartItens();
        isLoading = false;
        onSuccess();
        notifyListeners();
      } catch (e) {
        isLoading = false;
        onFail();
        notifyListeners();
      }
    }
  }

  Future<void> getComboCartItens() async {
    if (isLoggedIn()) {
      try {
        QuerySnapshot comboQuery = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .collection("cart")
            .get();
        comboCartList.clear();
        comboQuery.docs.map((queryDoc) {
          if (queryDoc.get("type") == "combo") {
            comboCartList.add(
              ComboData.fromCartQueryDocument(queryDoc),
            );
          }
        }).toList();
        if (comboCartList.length > 0) {
          hasProductInCart = true;
        }
        notifyListeners();
      } catch (erro) {}
    }
  }

  void incComboCartItem({
    @required ComboData cartComboData,
  }) async {
    print("ok");
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("cart")
          .doc(cartComboData.id)
          .update({
        "quantity": cartComboData.quantity + 1,
      });
    } catch (erro) {
      print(erro);
    }
  }

  void decComboCartItem({
    @required ComboData cartComboData,
  }) async {
    if (isLoggedIn()) {
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .collection("cart")
            .doc(cartComboData.id)
            .update({
          "quantity": cartComboData.quantity - 1,
        });
      } catch (erro) {}
    }
  }

  void removeComboCartItem({
    @required ComboData cartComboData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    try {
      comboCartList.remove(cartComboData);
      notifyListeners();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("cart")
          .doc(cartComboData.id)
          .delete();

      onSuccess();
      notifyListeners();
    } catch (erro) {
      onFail();
      notifyListeners();
    }
  }
}
