import 'dart:io';

import 'package:bd_app_full/data/cart_product.dart';
import 'package:bd_app_full/data/category_data.dart';
import 'package:bd_app_full/data/category_store_data.dart';
import 'package:bd_app_full/data/combo_data.dart';
import 'package:bd_app_full/data/coupon_data.dart';
import 'package:bd_app_full/data/credit_debit_card_Item.dart';
import 'package:bd_app_full/data/credit_debit_card_data.dart';
import 'package:bd_app_full/data/delivery_man_data.dart';
import 'package:bd_app_full/data/incremental_options_data.dart';
import 'package:bd_app_full/data/offs_data.dart';
import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/data/payment_form_data.dart';
import 'package:bd_app_full/data/payment_on_delivery_date.dart';
import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/data/request_partner_data.dart';
import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/data/subsection_data.dart';
import 'package:bd_app_full/data/user_data.dart';
import 'package:bd_app_full/screens/address_data.dart';
import 'package:bd_app_full/services/cielo_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';

const token = '635289558f18ba4c749d6928e8cd0ba7';

class UserModel extends Model {
  bool isLoading = false;
  bool isReady = false;
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
  List<OffData> offCartData = [];
  String addressToRegisterPartner = '';
  bool isLocationChoosedOnRegisterPartner = false;
  double _latPartnerRequest;
  double _lngPartnerRequest;
  String userAddresId;
  SubSectionData newSubsectionData;
  List<DeliveryManData> deliveryMans = [];
  LatLng latLngDevice;
  LatLng realTimeDeliveryManCoordinates;
  bool isLogged = false;
  Location location = new Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  List<OrderData> deliveryManRacers = [];
  Geodesy geodesy = Geodesy();
  FirebaseApp app;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<CouponData> couponsList = [];
  Position userPostion;
  List<AddressData> userAddress = [];
  bool listenChangeUser = false;
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) async {
    _loadCurrentUser();
    super.addListener(listener);
  }

  bool isLoggedIn() {
    return firebaseUser != null; //firebaseUser != null;
  }

  void _loadCurrentUser() async {
    isLoading = true;
    notifyListeners();
    if (firebaseUser == null) {
      firebaseUser = _auth.currentUser;
      isLogged = isLoggedIn();
      await _determinePosition();
      app = await Firebase.initializeApp(
        options: FirebaseOptions(
          appId: '1:411754724192:android:b29a3de213a1a3a1f5fc05',
          apiKey: 'AIzaSyBM1dpcPk1SFic6Frb2pDXcSlog9Qi9Y3s',
          messagingSenderId: '411754724192',
          projectId: 'bahia-delivery-app-cp',
          databaseURL: 'bahia-delivery-app-cp.appspot.com',
        ),
      );
      isLoggedIn();
      try {
        listenChangeUser = true;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .get()
            .then((value) async {
          userData = UserData.fromDocumentSnapshot(value);
          notifyListeners();
          getUserAddresses();
          await getListOfCategory();
          await getListHomeStores();
          await getOrders();
          getcartProductList();
          getComboCartItens();
          getPaymentUserForms();
          updateFavoritList();
          getDeliveryPartnersList();
          getPartnerData();
          getProductsPartnerList();
          getSectionList();
          getPartnerOffSales();
          getComboList();
          getPartnerOrderList();
          getPurchasedStoresList();
          getAllProductsToList();
          getPaymentUserForms();
          getDeliveryManData();
          getListOfCoupons();
          isLoading = false;
          isReady = true;
          listenChangeUser = false;
          notifyListeners();
          updateUser();
        });
      } catch (erro) {
        print(erro);
        isLoading = false;
        notifyListeners();
      }
    } else {
      isLoading = false;
      notifyListeners();
    }
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
        await FirebaseFirestore.instance.collection("errors").add({
          "erro": "Google Sign up" + "googleSignInAccount == null",
          "userId": firebaseUser.uid,
          "errorAt": DateTime.now(),
        });
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
      FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("addresses")
          .snapshots()
          .listen((querySnapshot) {
        userAddress.clear();
        querySnapshot.docs.map((query) {
          userAddress.add(
            AddressData.fromQueryDocumentSnapshot(query),
          );
        }).toList();
        notifyListeners();
      });
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
      }
      saveToken();
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .get()
            .then((value) {
          userData = UserData.fromDocumentSnapshot(value);
        });
      } catch (error) {
        await FirebaseFirestore.instance.collection("errors").add({
          "erro": "Google Sign in" + error.toString(),
          "userId": firebaseUser.uid,
          "errorAt": DateTime.now(),
        });
      }
      await getListOfCategory();
      await getListHomeStores();
      await getOrders();
      getUserAddresses();
      isLogged = true;
      notifyListeners();
      getcartProductList();
      getComboCartItens();
      getPaymentUserForms();
      updateFavoritList();
      getDeliveryPartnersList();
      getPartnerData();
      getProductsPartnerList();
      getSectionList();
      getPartnerOffSales();
      getComboList();
      getPartnerOrderList();
      getPurchasedStoresList();
      getAllProductsToList();
      getPaymentUserForms();
      getDeliveryManData();
      getListOfCoupons();
      onSuccess();
      isLoading = false;
      isReady = true;
      notifyListeners();
      updateUser();
    } catch (error) {
      onFail();
      await FirebaseFirestore.instance.collection("errors").add({
        "erro": "Google Sign up" + error.toString(),
        "userId": firebaseUser.uid,
        "errorAt": DateTime.now(),
      });
    }
  }

  Future<void> signUp({
    @required UserData user,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
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
      userData = UserData(
        name: user.name,
        image: "https://meuvidraceiro.com.br/images/sem-imagem.png",
        email: user.email,
        isPartner: 3,
        storeId: "",
        deliveryManId: "",
      );
      saveToken();
      await getListOfCategory();
      await getListHomeStores();
      await getOrders();
      getUserAddresses();
      getcartProductList();
      getComboCartItens();
      onSuccess();
      isLogged = true;
      isLoading = false;
      isReady = true;
      notifyListeners();
      getPaymentUserForms();
      updateFavoritList();
      getDeliveryPartnersList();
      getPartnerData();
      getProductsPartnerList();
      getSectionList();
      getPartnerOffSales();
      getComboList();
      getPartnerOrderList();
      getPurchasedStoresList();
      getAllProductsToList();
      getPaymentUserForms();
      getDeliveryManData();
      getListOfCoupons();
      app = await Firebase.initializeApp(
        options: FirebaseOptions(
          appId: '1:411754724192:android:b29a3de213a1a3a1f5fc05',
          apiKey: 'AIzaSyBM1dpcPk1SFic6Frb2pDXcSlog9Qi9Y3s',
          messagingSenderId: '411754724192',
          projectId: 'bahia-delivery-app-cp',
          databaseURL: 'bahia-delivery-app-cp.appspot.com',
        ),
      );
      notifyListeners();
    } catch (error) {
      isLogged = false;
      isLoading = false;
      onFail();
      await FirebaseFirestore.instance.collection("errors").add({
        "erro": error.toString(),
        "userId": firebaseUser.uid,
        "errorAt": DateTime.now(),
      });
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
      isLoading = true;
      notifyListeners();
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      this.firebaseUser = result.user;
      saveToken();
      try {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .get();
        userData = UserData(
          name: docUser.get("name"),
          image: docUser.get("image"),
          email: firebaseUser.email,
          isPartner: 1,
          storeId: docUser.get("isPartner") == 1 ? docUser.get("storeId") : "",
          deliveryManId:
              docUser.get("isPartner") == 6 ? docUser.get("deliveryManId") : "",
        );
      } catch (erro) {
        print(erro);
      }
      await getListOfCategory();
      await getListHomeStores();
      await getOrders();
      getUserAddresses();
      onSuccess();
      isLogged = true;
      isLoading = false;
      isReady = true;
      notifyListeners();
      getcartProductList();
      getComboCartItens();
      getPaymentUserForms();
      updateFavoritList();
      getDeliveryPartnersList();
      getPartnerData();
      getProductsPartnerList();
      getSectionList();
      getPartnerOffSales();
      getComboList();
      getPartnerOrderList();
      getPurchasedStoresList();
      getAllProductsToList();
      getPaymentUserForms();
      getDeliveryManData();
      getListOfCoupons();
      app = await Firebase.initializeApp(
        options: FirebaseOptions(
          appId: '1:411754724192:android:b29a3de213a1a3a1f5fc05',
          apiKey: 'AIzaSyBM1dpcPk1SFic6Frb2pDXcSlog9Qi9Y3s',
          messagingSenderId: '411754724192',
          projectId: 'bahia-delivery-app-cp',
          databaseURL: 'bahia-delivery-app-cp.appspot.com',
        ),
      );
      notifyListeners();
    } catch (error) {
      isLogged = true;
      isLoading = false;
      onFail();
      notifyListeners();
      await FirebaseFirestore.instance.collection("errors").add({
        "erro": error.toString(),
        "userId": firebaseUser.uid,
        "errorAt": DateTime.now(),
      });
    }
  }

  void signOut({
    @required VoidCallback onSuccess,
  }) async {
    isLoading = true;
    notifyListeners();
    await _auth.signOut();
    firebaseUser = null;
    onSuccess();
    isLogged = false;
    isLoading = false;
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
      await _determinePosition();
      saveToken();
      _loadCurrentUser();
      onSuccess();
      notifyListeners();
    } catch (error) {
      await FirebaseFirestore.instance.collection("errors").add({
        "erro": "Google Sign in 2" + error.toString(),
        "userId": firebaseUser.uid,
        "errorAt": DateTime.now(),
      });
      print(error);
    }
  }

  void signInWithFacebook({
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) {}

  Future<void> getListOfCategory() async {
    try {
      FirebaseFirestore.instance
          .collection("categories")
          .snapshots()
          .listen((querySnashot) {
        categoryList.clear();
        querySnashot.docs
            .map((queryDoc) =>
                categoryList.add(CategoryData.fromQueryDocument(queryDoc)))
            .toList();
        notifyListeners();
      });
    } catch (erro) {
      print(erro);
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
        FirebaseFirestore.instance
            .collection("orders")
            .orderBy(
              "createdAt",
              descending: true,
            )
            .snapshots()
            .listen((querySnapshot) {
          listUserOrders.clear();
          querySnapshot.docs.map((queryDoc) async {
            if (queryDoc.get("client") == firebaseUser.uid) {
              listUserOrders.add(OrderData.fromQueryDocument(queryDoc));
            }
            if (queryDoc.get("deliveryMan") != "none") {
              if (queryDoc.data()["deliveryMan"]["userId"] ==
                  firebaseUser.uid) {
                deliveryManRacers.add(OrderData.fromQueryDocument(queryDoc));
              }
            }
          }).toList();
          notifyListeners();
        });
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("orders")
            .orderBy(
              "createdAt",
              descending: true,
            )
            .get();
        listUserOrders.clear();
        querySnapshot.docs.map((queryDoc) async {
          if (queryDoc.get("client") == firebaseUser.uid) {
            listUserOrders.add(OrderData.fromQueryDocument(queryDoc));
          }
          if (queryDoc.get("deliveryMan") != "none") {
            if (queryDoc.data()["deliveryMan"]["userId"] == firebaseUser.uid) {
              deliveryManRacers.add(OrderData.fromQueryDocument(queryDoc));
            }
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
      latLngDevice = LatLng(
        userPostion.latitude,
        userPostion.longitude,
      );
      try {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection("stores").get();
        storeHomeList.clear();
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
          storeElement.coupons = await getListOfCouponsByStore(storeElement.id);
        });
      } catch (erro) {
        sendErrorMessageToADM(
          errorFromUser: erro.toString(),
        );
        notifyListeners();
      }
    }
    FirebaseFirestore.instance
        .collection("stores")
        .snapshots()
        .listen((querySnapshot) {
      storeHomeList.clear();
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
                  if (!hasThisProduct) purchasedProducts.add(productDataStore);
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
        storeElement.coupons = await getListOfCouponsByStore(storeElement.id);
      });
    });
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
      if (userData.isPartner == 1) {
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection("stores")
            .doc(userData.storeId)
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

  void editSection({
    @required CategoryStoreData section,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    if (isLoggedIn()) {
      isLoading = true;
      notifyListeners();
      try {
        if (section.imageFile != null) {
          Reference ref = FirebaseStorage.instance.ref().child("images").child(
                DateTime.now().millisecond.toString(),
              );
          UploadTask uploadTask = ref.putFile(section.imageFile);
          uploadTask.then((task) async {
            section.image = await task.ref.getDownloadURL();
            print(section.order);
            int count = section.order;
            List<CategoryStoreData> flagSectionList = [];
            flagSectionList =
                sectionsStorePartnerList.sublist(0, section.order - 1);
            sectionsStorePartnerList.forEach((sectStore) {
              if (sectStore.order >= section.order) {
                sectStore.order = sectStore.order;
                flagSectionList.add(sectStore);
              }
            });
            flagSectionList.forEach((sectionToDataBase) async {
              print(sectionToDataBase.order);
              await FirebaseFirestore.instance
                  .collection("stores")
                  .doc(userData.storeId)
                  .collection("categories")
                  .doc(sectionToDataBase.id)
                  .update(
                    sectionToDataBase.toMap(),
                  );
            });
            section.order = section.order - 1;
            await FirebaseFirestore.instance
                .collection("stores")
                .doc(userData.storeId)
                .collection("categories")
                .doc(section.id)
                .update(
                  section.toMap(),
                );
            await getSectionList();
            onSuccess();
            isLoading = false;
            notifyListeners();
          });
        } else {
          print(section.order);
          int count = section.order;
          List<CategoryStoreData> flagSectionList = [];
          flagSectionList =
              sectionsStorePartnerList.sublist(0, section.order - 1);
          sectionsStorePartnerList.forEach((sectStore) {
            if (sectStore.order >= section.order) {
              sectStore.order = sectStore.order;
              flagSectionList.add(sectStore);
            }
          });
          flagSectionList.forEach((sectionToDataBase) async {
            print(sectionToDataBase.order);
            await FirebaseFirestore.instance
                .collection("stores")
                .doc(userData.storeId)
                .collection("categories")
                .doc(sectionToDataBase.id)
                .update(
                  sectionToDataBase.toMap(),
                );
          });
          section.order = section.order - 1;
          await FirebaseFirestore.instance
              .collection("stores")
              .doc(userData.storeId)
              .collection("categories")
              .doc(section.id)
              .update(
                section.toMap(),
              );
          await getSectionList();
          onSuccess();
          isLoading = false;
          notifyListeners();
        }
      } catch (error) {
        onFail();
        print(error);
        isLoading = false;
        notifyListeners();
      }
    }
  }

  void insertNewSection({
    @required CategoryStoreData section,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    if (isLoggedIn()) {
      isLoading = true;
      notifyListeners();
      try {
        Reference ref = FirebaseStorage.instance.ref().child("images").child(
              DateTime.now().millisecond.toString(),
            );
        UploadTask uploadTask = ref.putFile(section.imageFile);
        uploadTask.then((task) async {
          section.image = await task.ref.getDownloadURL();
          if (section.order == sectionsStorePartnerList.length) {
            await FirebaseFirestore.instance
                .collection("stores")
                .doc(userData.storeId)
                .collection("categories")
                .add(
                  section.toMap(),
                );
          } else {
            List<CategoryStoreData> flagSectionList = [];
            flagSectionList =
                sectionsStorePartnerList.sublist(0, section.order);
            sectionsStorePartnerList.forEach((sectStore) {
              if (sectStore.order >= section.order) {
                sectStore.order = sectStore.order + 1;
                flagSectionList.add(sectStore);
              }
            });
            await FirebaseFirestore.instance
                .collection("stores")
                .doc(userData.storeId)
                .collection("categories")
                .add(
                  section.toMap(),
                );
            flagSectionList.forEach((sectionToDataBase) async {
              await FirebaseFirestore.instance
                  .collection("stores")
                  .doc(userData.storeId)
                  .collection("categories")
                  .doc(sectionToDataBase.id)
                  .update(
                    sectionToDataBase.toMap(),
                  );
            });
          }
          await getSectionList();
          onSuccess();
          isLoading = false;
          notifyListeners();
        });
      } catch (error) {
        onFail();
        isLoading = false;
        notifyListeners();
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
        await getSectionList();
        onSucess();
        isLoading = false;
        notifyListeners();
      } catch (erro) {
        print(erro);
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
          print(erro);
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
    isLoading = true;
    notifyListeners();
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
          isLoading = false;
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
        isLoading = false;
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
            isLoading = false;
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
        partnerOrderList.clear();
        querySnapshot.docs.map((queryDoc) {
          partnerOrderList.add(OrderData.fromQueryDocument(queryDoc));
        }).toList();
      }
      FirebaseFirestore.instance
          .collection("orders")
          .orderBy(
            "createdAt",
            descending: true,
          )
          .snapshots()
          .listen((querySnapshot) {
        if (!isLoading) {
          partnerOrderList.clear();
          querySnapshot.docs.map((queryDoc) {
            partnerOrderList.add(OrderData.fromQueryDocument(queryDoc));
          }).toList();
        }
      });
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

  Future<void> finishOrderWithPayOnAppByDebitCard({
    @required double discount,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required double shipePrice,
    @required StoreData storeData,
    @required VoidCallback onCartExpired,
    @required VoidCallback onTimeOut,
    @required VoidCallback onFailDebitCard,
  }) async {
    if (isLoggedIn()) {
      final cieloPayment = new CieloPayment();

      Map response = {};
      double totalPrice = 0;
      comboCartList.forEach((combo) {
        totalPrice += (combo.price * combo.quantity);
      });
      cartProducts.forEach((product) {
        totalPrice += product.price;
      });
      totalPrice += shipePrice;
      response = await cieloPayment.authorizedDebitCard(
        creditDebitCardData: currentCreditDebitCardData,
        price: totalPrice,
      );
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .collection("cart")
            .get();
        if (response["payment"]["authenticate"] == true) {
          await FirebaseFirestore.instance.collection("orders").add({
            "client": firebaseUser.uid,
            "clientName": userData.name,
            "clientImage": userData.image,
            "userLocation": {
              "clientAddress": addressToRegisterPartner
                  .replaceAll("State of ", "")
                  .replaceAll("Brazil", "Brasil"),
              "lat": latLngDevice.latitude,
              "lng": latLngDevice.longitude,
              "addressId": userAddresId,
            },
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
            "storeLocation": {
              "storeAddress": storeData.storeAddress
                  .replaceAll("State of ", "")
                  .replaceAll("Brazil", "Brasil"),
              "lat": storeData.latLng.latitude,
              "lng": storeData.latLng.longitude,
              "addressId": storeData.locationId,
            },
            "deliveryMan": "none",
            'createdAt': FieldValue.serverTimestamp(),
            'platform': Platform.operatingSystem,
            'paymentType': "Pagamento no app",
            "method": "debitCard",
            "dataSale": response,
            "realTimeDeliveryManLocation": {},
          });
          getListOfCategory();
          getListHomeStores();
          await getOrders();
          onSuccess();
          notifyListeners();
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            doc.reference.delete();
          }
          cartProducts.clear();
          comboCartList.clear();
          hasProductInCart = false;
          getcartProductList();
          notifyListeners();
        } else {
          notifyListeners();
          onFailDebitCard();
        }
      } catch (erro) {}
    }
  }

  Future<void> finishOrderWithPayOnAppByCretditCard({
    @required double discount,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required double shipePrice,
    @required StoreData storeData,
    @required VoidCallback onCartExpired,
    @required VoidCallback onTimeOut,
  }) async {
    Map response = {};
    try {
      if (cartProducts.length == 0 && comboCartList.length == 0) return null;
      double totalPrice = 0;
      comboCartList.forEach((combo) {
        totalPrice += (combo.price * combo.quantity);
      });
      cartProducts.forEach((product) {
        totalPrice += product.price;
      });
      totalPrice += shipePrice;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("cart")
          .get();

      final cieloPayment = new CieloPayment();
      response = await cieloPayment.authorized(
        creditDebitCardData: currentCreditDebitCardData,
        price: totalPrice,
      );
      if (response["payment"]["returnMessage"] == "Operation Successful") {
        await FirebaseFirestore.instance.collection("orders").add({
          "client": firebaseUser.uid,
          "clientName": userData.name,
          "clientImage": userData.image,
          "userLocation": {
            "clientAddress": addressToRegisterPartner
                .replaceAll("State of ", "")
                .replaceAll("Brazil", "Brasil"),
            "lat": latLngDevice.latitude,
            "lng": latLngDevice.longitude,
            "addressId": userAddresId,
          },
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
          "storeLocation": {
            "storeAddress": storeData.storeAddress
                .replaceAll("State of ", "")
                .replaceAll("Brazil", "Brasil"),
            "lat": storeData.latLng.latitude,
            "lng": storeData.latLng.longitude,
            "addressId": storeData.locationId,
          },
          "discount": discount,
          "totalPrice": totalPrice,
          "deliveryMan": "none",
          "status": 1,
          'createdAt': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem,
          'paymentType': "Pagamento no app",
          "method": "creditCard",
          "dataSale": response,
          "realTimeDeliveryManLocation": {},
        });
        getListOfCategory();
        getListHomeStores();
        await getOrders();
        onSuccess();
        notifyListeners();
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          doc.reference.delete();
        }
        cartProducts.clear();
        comboCartList.clear();
        hasProductInCart = false;
        notifyListeners();
      } else if (response["payment"]["returnMessage"] == "Card Expired") {
        onCartExpired();
        notifyListeners();
      } else if (response["payment"]["returnMessage"] == "Timeout") {
        onTimeOut();
        notifyListeners();
      }
    } catch (erro) {
      onFail();
      print(erro);
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
      try {
        double totalPrice = 0;
        comboCartList.forEach((combo) {
          totalPrice += (combo.price * combo.quantity);
        });
        cartProducts.forEach((product) {
          totalPrice += product.price;
        });
        totalPrice += shipePrice;
        if (cartProducts.length == 0 && comboCartList.length == 0) return null;
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .collection("cart")
            .get();

        await FirebaseFirestore.instance.collection("orders").add({
          "client": firebaseUser.uid,
          "clientName": userData.name,
          "clientImage": userData.image,
          "userLocation": {
            "clientAddress": addressToRegisterPartner
                .replaceAll("State of ", "")
                .replaceAll("Brazil", "Brasil"),
            "lat": latLngDevice.latitude,
            "lng": latLngDevice.longitude,
            "addressId": userAddresId,
          },
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
          "storeLocation": {
            "storeAddress": storeData.storeAddress
                .replaceAll("State of ", "")
                .replaceAll("Brazil", "Brasil"),
            "lat": storeData.latLng.latitude,
            "lng": storeData.latLng.longitude,
            "addressId": storeData.locationId,
          },
          "discount": discount,
          "deliveryMan": "none",
          "totalPrice": totalPrice,
          "status": 1,
          'createdAt': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem,
          'paymentType': "Pagamento na Entrega",
          'dataSale': {},
          "realTimeDeliveryManLocation": {},
        });
        cartProducts.clear();
        comboCartList.clear();
        hasProductInCart = false;
        onSuccess();
        notifyListeners();
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          doc.reference.delete();
        }
        await getOrders();
        await getListHomeStores();
        await updateFavoritList();
        notifyListeners();
      } catch (e) {
        onFail();
        print(e);
      }
    }
  }

  void updateUser() async {
    if (isLoggedIn()) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .snapshots()
          .listen((queryDoc) async {
        if (queryDoc.get("isPartner") != userData.isPartner) {
          print("ok");
          try {
            listenChangeUser = true;
            notifyListeners();
            DocumentSnapshot docUser = await FirebaseFirestore.instance
                .collection("users")
                .doc(firebaseUser.uid)
                .get();
            userData = UserData(
              name: docUser.get("name"),
              image: docUser.get("image"),
              email: docUser.get("email"),
              isPartner: queryDoc.get("isPartner"),
              storeId:
                  docUser.get("isPartner") == 1 ? docUser.get("storeId") : "",
              deliveryManId: docUser.get("isPartner") == 6
                  ? docUser.get("deliveryManId")
                  : "",
            );
            await getListOfCategory();
            await getListHomeStores();
            await getOrders();
            getUserAddresses();
            isLogged = true;
            isLoading = false;
            isReady = true;
            notifyListeners();
            getcartProductList();
            getComboCartItens();
            getPaymentUserForms();
            updateFavoritList();
            getDeliveryPartnersList();
            getPartnerData();
            getProductsPartnerList();
            getSectionList();
            getPartnerOffSales();
            getComboList();
            getPartnerOrderList();
            getPurchasedStoresList();
            getAllProductsToList();
            getPaymentUserForms();
            getDeliveryManData();
            getListOfCoupons();
            listenChangeUser = false;
            isLoading = false;
            isReady = true;
            notifyListeners();
          } catch (erro) {
            print(erro);
            listenChangeUser = false;
            isLoading = false;
            isReady = true;
            notifyListeners();
          }
        }
      });
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
    creditDebitCardList.clear();
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
      QuerySnapshot paymentQuery = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("paymentForms")
          .get();
      paymentFormsList.clear();
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
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    userPostion = await Geolocator.getCurrentPosition();
    return userPostion;
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
        offCartData.clear();
        comboQuery.docs.map((queryDoc) {
          if (queryDoc.get("type") == "combo") {
            comboCartList.add(
              ComboData.fromCartQueryDocument(queryDoc),
            );
          }
          if (queryDoc.get("type") == "off") {
            offCartData.add(
              OffData.fromQueryDocument(queryDoc),
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

  void setAddressToRegister({
    @required String address,
    double lat,
    double lng,
    String addressId,
    VoidCallback onSuccess,
    VoidCallback onFail,
    VoidCallback initLoad,
  }) async {
    addressToRegisterPartner = address;
    _latPartnerRequest = lat;
    _lngPartnerRequest = lng;
    userAddresId = addressId;
    isLocationChoosedOnRegisterPartner = true;
    addressSeted = true;
    latLngDevice = LatLng(
      lat,
      lng,
    );
    final addressData = AddressData(
      address: address,
      addressId: addressId,
      lat: lat,
      lng: lng,
    );
    try {
      isLoading = true;
      initLoad();
      notifyListeners();
      storeHomeList.clear();
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
                  if (!hasThisProduct) purchasedProducts.add(productDataStore);
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
      updateFavoritList();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("addresses")
          .add(
            addressData.toMap(),
          );
      onSuccess();
      isLoading = false;
      notifyListeners();
    } catch (erro) {
      sendErrorMessageToADM(
        errorFromUser: erro.toString(),
      );
      print(erro);
      onFail();
      notifyListeners();
    }
    notifyListeners();
  }

  void sendRequestForNewPartner({
    @required RequestPartnerData requestPartnerData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required VoidCallback onFailImage,
  }) async {
    if (isLoggedIn()) {
      isLoading = true;
      notifyListeners();
      categoryList.forEach((element) {
        if (element.title == requestPartnerData.category) {
          requestPartnerData.categoryId = element.id;
        }
      });
      requestPartnerData.userId = firebaseUser.uid;
      requestPartnerData.lat = _latPartnerRequest;
      requestPartnerData.lng = _lngPartnerRequest;
      requestPartnerData.locationId = userAddresId;
      requestPartnerData.storeAddress = addressToRegisterPartner;
      if (requestPartnerData.imageFile == null) {
        onFailImage();
      } else {
        try {
          Reference ref = FirebaseStorage.instance.ref().child("images").child(
                DateTime.now().millisecond.toString(),
              );
          UploadTask uploadTask = ref.putFile(requestPartnerData.imageFile);
          await uploadTask.then(
            (task) async {
              requestPartnerData.image = await task.ref.getDownloadURL();
              await FirebaseFirestore.instance
                  .collection("requests")
                  .add(
                    requestPartnerData.toMap(),
                  )
                  .then((value) {
                requestPartnerData.id = value.id;
              });
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(firebaseUser.uid)
                  .update(
                {
                  "isPartner": 2,
                  "requestId": requestPartnerData.id,
                },
              );
            },
          );
          onSuccess();
          isLoading = false;
          notifyListeners();
        } catch (erro) {
          print(erro);
        }
      }
    }
  }

  void sendRequestForNewDeliveryMan({
    @required DeliveryManData deliveryManData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();
    if (isLoggedIn()) {
      try {
        deliveryManData.userId = firebaseUser.uid;
        deliveryManData.lat = _latPartnerRequest;
        deliveryManData.lng = _lngPartnerRequest;
        deliveryManData.locationId = userAddresId;
        deliveryManData.location = addressToRegisterPartner;

        Reference ref = FirebaseStorage.instance.ref().child("images").child(
              DateTime.now().millisecond.toString(),
            );
        UploadTask uploadTask = ref.putFile(deliveryManData.imageFile);
        await uploadTask.then((task) async {
          deliveryManData.image = await task.ref.getDownloadURL();
          Reference refDriver =
              FirebaseStorage.instance.ref().child("images").child(
                    DateTime.now().millisecond.toString(),
                  );
          UploadTask uploadDriverTask =
              refDriver.putFile(deliveryManData.driverImageFile);
          await uploadDriverTask.then((driverTask) async {
            deliveryManData.driverIdImage =
                await driverTask.ref.getDownloadURL();
            await FirebaseFirestore.instance
                .collection("requestsDeliveryMans")
                .add(
                  deliveryManData.toRequestMap(),
                );
            await FirebaseFirestore.instance
                .collection("users")
                .doc(firebaseUser.uid)
                .update({
              "isPartner": 5,
            });
            onSuccess();
            isLoading = false;
            notifyListeners();
          });
        });
      } catch (erro) {
        isLoading = false;
        notifyListeners();
        print(erro);
      }
    }
  }

  Future<void> getDeliveryManData() async {
    if (isLoggedIn()) {
      if (userData.isPartner == 6) {
        try {
          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
              .collection("deliveryMans")
              .doc(userData.deliveryManId)
              .get();
          userData.userDeliveryMan =
              DeliveryManData.fromDocument(documentSnapshot);
        } catch (erro) {}
      }
    }
  }

  void setDebitCard(bool isDebit) {
    currentCreditDebitCardData.isDebit = isDebit;
    notifyListeners();
  }

  void getDeliveryPartnersList() async {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        try {
          QuerySnapshot deliveryQuery =
              await FirebaseFirestore.instance.collection("deliveryMans").get();
          deliveryMans.clear();
          deliveryQuery.docs
              .map(
                (docSnap) => deliveryMans.add(
                  DeliveryManData.fromQuerySnapshot(docSnap),
                ),
              )
              .toList();
          notifyListeners();
        } catch (erro) {}
      }
    }
  }

  void setDeliveryManToOrder({
    @required DeliveryManData deliveryManData,
    @required String orderId,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    if (isLoggedIn()) {
      try {
        await FirebaseFirestore.instance
            .collection("orders")
            .doc(orderId)
            .update(
          {
            "deliveryMan": deliveryManData.toRequestMap(),
          },
        );
        onSuccess();
        notifyListeners();
      } catch (error) {
        onFail();
        notifyListeners();
      }
    }
  }

  void getDeliveryManRacers(OrderData delioveyManOrder) {
    if (isLoggedIn()) {
      if (userData.isPartner == 6) {
        deliveryManRacers.add(delioveyManOrder);
      }
    }
  }

  void setStatusOrder(
      {@required OrderData orderData, @required int status}) async {
    if (isLoggedIn()) {
      await FirebaseFirestore.instance
          .collection("orders")
          .doc(orderData.id)
          .update({
        "status": status,
      });
    }
  }

  void setLocationdDeliveryManOrder({
    @required OrderData orderData,
    @required double lat,
    @required double lng,
    @required double distanceRemaining,
    @required double durationRemaining,
  }) async {
    if (isLoggedIn()) {
      DatabaseReference coordinates = FirebaseDatabase.instance
          .reference()
          .child("orders")
          .child(orderData.id)
          .child("deliveryRealTimeLocation");
      await coordinates.runTransaction((MutableData mutableData) async {
        mutableData.value = {
          "lat": lat,
          "lng": lng,
          "distanceRemaining": distanceRemaining,
          "durationRemaining": durationRemaining,
        };
        return mutableData;
      });
    }
  }

  void getRealTimeDeliveryManPosition({@required lat, @required lng}) {
    realTimeDeliveryManCoordinates = LatLng(lat, lng);
    notifyListeners();
  }

  void sendtextMessageByUser({
    @required ChatMessage message,
    @required OrderData orderData,
  }) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderData.id)
        .collection("chat")
        .add(message.toJson());
  }

  void sendImageMessageByUser({
    @required File imageFile,
    @required OrderData orderData,
    @required ChatUser user,
  }) async {
    if (imageFile == null) return;
    Reference ref =
        FirebaseStorage.instance.ref().child("chat").child("images").child(
              DateTime.now().millisecond.toString(),
            );
    UploadTask uploadTask = ref.putFile(imageFile);
    await uploadTask.then((task) async {
      String url = await task.ref.getDownloadURL();
      ChatMessage message = ChatMessage(text: "", user: user, image: url);
      await FirebaseFirestore.instance
          .collection("orders")
          .doc(orderData.id)
          .collection("chat")
          .add(message.toJson());
    });
  }

  Future<void> authorizePayByPartner({
    @required OrderData orderData,
  }) async {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        try {
          DocumentSnapshot orderDoc = await FirebaseFirestore.instance
              .collection("orders")
              .doc(orderData.id)
              .get();
          if (orderData.paymentType == 'Pagamento no app') {
            Map response = {};
            String paymentId =
                orderDoc.data()["dataSale"]["payment"]["paymentId"];
            final cieloPayment = new CieloPayment();
            response = await cieloPayment.capturePayByCard(
              paymentId: paymentId,
            );
            if (response['returnMessage'] == 'Operation Successful') {
              orderDoc.reference.update({
                "status": 2,
              });
            }
          } else {
            orderDoc.reference.update({
              "status": 2,
            });
          }
        } catch (erro) {}
      }
    }
  }

  Future<void> cancelPayByPartner({
    @required OrderData orderData,
  }) async {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        try {
          DocumentSnapshot orderDoc = await FirebaseFirestore.instance
              .collection("orders")
              .doc(orderData.id)
              .get();
          if (orderData.paymentType == 'Pagamento no app') {
            Map response = {};
            String paymentId =
                orderDoc.data()["dataSale"]["payment"]["paymentId"];
            final cieloPayment = new CieloPayment();
            response = await cieloPayment.cancelPayByCard(
              paymentId: paymentId,
              amount: (orderData.totalPrice * 100).toInt(),
            );
            if (response['returnMessage'] == 'Operation Successful') {
              orderDoc.reference.update({
                "status": 5,
              });
            }
          } else {
            orderDoc.reference.update({
              "status": 5,
            });
          }
        } catch (error) {
          print(error);
        }
      }
    }
  }

  void getListOfCoupons() {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        try {
          FirebaseFirestore.instance
              .collection("stores")
              .doc(userData.storeId)
              .collection("coupons")
              .snapshots()
              .listen((querySnapshot) {
            couponsList.clear();
            querySnapshot.docs.map((queryDoc) {
              couponsList.add(
                CouponData.fromQueryDocumentSnapshot(queryDoc),
              );
            }).toList();
            notifyListeners();
          });
        } catch (error) {}
      }
    }
  }

  void createNewCouponData({
    @required CouponData couponData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        try {
          await FirebaseFirestore.instance
              .collection("stores")
              .doc(userData.storeId)
              .collection("coupons")
              .add(
                couponData.toMap(),
              );
        } catch (error) {}
      }
    }
  }

  void editCouponData({
    @required CouponData couponData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    if (isLoggedIn()) {
      if (userData.isPartner == 1) {
        try {
          await FirebaseFirestore.instance
              .collection("stores")
              .doc(userData.storeId)
              .collection("coupons")
              .doc(couponData.id)
              .update(
                couponData.toMap(),
              );
        } catch (error) {}
      }
    }
  }

  Future<List<CouponData>> getListOfCouponsByStore(String storeid) async {
    List<CouponData> couponData = [];
    if (isLoggedIn()) {
      int discount = 0;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("stores")
          .doc(storeid)
          .collection("coupons")
          .get();
      querySnapshot.docs.map((queryDoc) {
        couponData.add(
          CouponData.fromQueryDocumentSnapshot(queryDoc),
        );
      }).toList();
    }
    return couponData;
  }

  void insertOffCart({
    @required OffData offData,
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
              offData.toOffCartMap(),
            );
        isLoading = false;
        onSuccess();
        notifyListeners();
      } catch (error) {
        onFail();
        isLoading = false;
        notifyListeners();
      }
    }
  }

  void getUserAddresses() async {
    if (isLogged) {
      try {
        FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .collection("addresses")
            .snapshots()
            .listen((querySnapshot) {
          userAddress.clear();
          querySnapshot.docs.map((query) {
            userAddress.add(
              AddressData.fromQueryDocumentSnapshot(query),
            );
          }).toList();
          notifyListeners();
        });
      } catch (erro) {}
    }
  }

  void setAddressWithoutSaving({
    @required String address,
    double lat,
    double lng,
    String addressId,
    VoidCallback onSuccess,
    VoidCallback onFail,
    VoidCallback initLoad,
  }) async {
    addressToRegisterPartner = address;
    _latPartnerRequest = lat;
    _lngPartnerRequest = lng;
    userAddresId = addressId;
    isLocationChoosedOnRegisterPartner = true;
    addressSeted = true;
    latLngDevice = LatLng(
      lat,
      lng,
    );
    try {
      isLoading = true;
      initLoad();
      notifyListeners();
      storeHomeList.clear();
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
                  if (!hasThisProduct) purchasedProducts.add(productDataStore);
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
      updateFavoritList();
      onSuccess();
      isLoading = false;
    } catch (erro) {
      sendErrorMessageToADM(
        errorFromUser: erro.toString(),
      );
      print(erro);
      onFail();
      notifyListeners();
    }
    notifyListeners();
  }
}
