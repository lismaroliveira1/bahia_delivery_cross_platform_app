import 'dart:collection';
import 'dart:io';
import 'package:bahia_delivery/data/address_data.dart';
import 'package:bahia_delivery/data/address_data_from_google.dart';
import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/data/category_data.dart';
import 'package:bahia_delivery/data/credit_debit_card_data.dart';
import 'package:bahia_delivery/data/credit_debit_card_item.dart';
import 'package:bahia_delivery/data/incremental_optional_data.dart';
import 'package:bahia_delivery/data/order_data.dart';
import 'package:bahia_delivery/data/payment_on_delivery_date.dart';
import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/data/sales_off_data.dart';
import 'package:bahia_delivery/data/search_data.dart';
import 'package:bahia_delivery/data/store_categore_data.dart';
import 'package:bahia_delivery/data/store_data.dart';
import 'package:bahia_delivery/data/store_with_cpf_data.dart';
import 'package:bahia_delivery/models/adress.dart';
import 'package:bahia_delivery/data/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

const token = '635289558f18ba4c749d6928e8cd0ba7';

class UserModel extends Model {
  Map<String, dynamic> userData = Map();
  List<AddressDataFromGoogle> addressDataFromGoogleList = [];
  FirebaseUser firebaseUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  int isPartner = 3;
  double longittude;
  double latitude;
  int favoriteStoryQuantity = 0;
  List<AddressData> addresses = [];
  List<CreditDebitCardData> creditDebitCardList = [];
  List<CategoryData> categoryDataList = [];
  List<StoreData> storeDataList = [];
  List<StoreData> storeListFavorites = [];
  List<OrderData> listUserOrders = [];
  List<OrderData> listPartnerOders = [];
  List<IncrementalOptData> incrementalOptDataList = [];
  List<IncrementalOptData> productIncrementals = [];
  String street;
  String state;
  String zipCode;
  String district;
  String city;
  AddressData currentUserAddress;
  String currentUserId;
  bool addressSeted = false;
  bool errorSignGoogle = false;
  bool errorSignFacebook = false;
  bool isLogged = false;
  bool paymentSet = false;
  CreditDebitCardData currentCreditDebitCardData;
  PaymentOnDeliveryData currentPaymentOndeliveryData;
  bool payOnApp;
  StoreData storeData;
  CategoryData categoryData;
  bool hasStories = false;
  String userName;
  String userImage;
  String userPhoneNumber = '';
  String userEmail;
  String storeName = "";
  String storeImage = "";
  String storeId = "";
  bool hasPartnerOrders = false;
  OrderData chatOrderData;
  AddressDataFromGoogle currentAddressDataFromGoogle;
  List<ProductData> productsStore = [];
  List<StoreCategoreData> storesCategoresList = [];
  List<SalesOffData> salesOffList = [];
  List<ProductData> purchasedsProducts = [];
  List<DocumentSnapshot> purchasedProductsByStore = [];
  bool hasSalesOff = false;
  bool hasProductInCart = false;
  List<CartProduct> productsInCart = [];
  bool isStoreHourConfigurated = false;
  List<StoreData> lastPurchasedStores = [];
  List<OrderData> allOrders = [];
  List<StoreData> storeDataListOpened = [];
  List<StoreData> storeDataListClosed = [];

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);
  @override
  void addListener(VoidCallback listener) async {
    super.addListener(listener);

    _loadCurrentUser();
    _getCurrentLocation();
    _loadListCreditDebitCard();
    _loadAddressFromGoogle();
    loadAddressItems();
    updateCategory();
    updateStories();
    updateStoreFavorites();
    updatePartnerData();
    veryIfExistsProducts();
  }

  Future<void> signIn({
    @required String email,
    @required String pass,
    @required Function onFail,
    @required Function onSuccess,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final AuthResult result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      this.firebaseUser = result.user;
      onSuccess();
      saveToken();
      getAllUserData();
      updatePartnerData();
      isLoading = false;
      isLogged = true;
      notifyListeners();
    } on PlatformException catch (_) {
      onFail();
      isLoading = false;
      notifyListeners();
      isLogged = false;
    }
  }

  Future<void> signUpWithGoogle({
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required VoidCallback onFailGoogle,
  }) async {
    isLoading = true;
    notifyListeners();
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
    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    final AuthResult authResult =
        await FirebaseAuth.instance.signInWithCredential(authCredential);

    try {
      DocumentSnapshot docUser = await Firestore.instance
          .collection("users")
          .document(authResult.user.uid)
          .get();
      if (docUser.exists) {
        await _auth.signOut();
        userData = Map();
        firebaseUser = null;
        onFailGoogle();
        isLogged = false;
        isLoading = false;
        notifyListeners();
      } else {
        userName = authResult.user.displayName;
        userImage = authResult.user.photoUrl;
        final user = User(
            name: authResult.user.displayName,
            email: authResult.user.email,
            image: authResult.user.photoUrl,
            isPartner: 3,
            currentAddress: "");
        this.firebaseUser = authResult.user;
        _saveUserData(user);
        isLogged = true;
        getAllUserData();
        saveToken();
        onSuccess();
        updatePartnerData();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLogged = false;
      print(e);
      onFail();
    }
  }

  Future<void> signInWithGoogle(
      {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

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
    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    final AuthResult authResult =
        await FirebaseAuth.instance.signInWithCredential(authCredential);

    try {
      DocumentSnapshot docUser = await Firestore.instance
          .collection("users")
          .document(authResult.user.uid)
          .get();
      if (docUser.exists) {
        userName = authResult.user.displayName;
        userImage = authResult.user.photoUrl;
        this.firebaseUser = authResult.user;
        updatePartnerData();
        getAllUserData();
        isLogged = true;
        saveToken();
        isLoading = false;
        notifyListeners();
      } else {
        await _auth.signOut();
        userData = Map();
        firebaseUser = null;
        isLogged = false;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      errorSignGoogle = true;
      isLoading = false;
      isLogged = false;
      notifyListeners();
    }
  }

  Future<void> signInWithFacebook(
      {@required onSuccess, @required onFail}) async {
    isLoading = false;
    notifyListeners();
    final FacebookLogin facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        final authResult = await _auth.signInWithCredential(credential);
        if (authResult.user != null) {
          DocumentSnapshot docUser = await Firestore.instance
              .collection("users")
              .document(authResult.user.uid)
              .get();
          if (docUser.exists) {
            this.firebaseUser = authResult.user;
            updatePartnerData();
            getAllUserData();
            isLogged = true;
            saveToken();
            isLoading = false;
            notifyListeners();
          } else {
            await _auth.signOut();
            userData = Map();
            firebaseUser = null;
            isLogged = false;
            isLoading = false;
            notifyListeners();
          }
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        // TODO: Handle this case.
        isLogged = false;
        break;
      case FacebookLoginStatus.error:
        errorSignFacebook = true;
        isLogged = false;
        isLoading = false;
        notifyListeners();
        break;
    }
  }

  Future<void> signUpWithFacebook({
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required onFailFacebbok,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final FacebookLogin facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email', 'public_profile']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token,
          );

          final authResult = await _auth.signInWithCredential(credential);
          if (authResult.user != null) {
            DocumentSnapshot docUser = await Firestore.instance
                .collection("users")
                .document(authResult.user.uid)
                .get();
            if (docUser.exists) {
              await _auth.signOut();
              userData = Map();
              firebaseUser = null;
              onFail();
              isLogged = false;
              isLoading = false;
              notifyListeners();
            } else {
              final user = User(
                  name: authResult.user.displayName,
                  email: authResult.user.email,
                  isPartner: 3,
                  currentAddress: "");
              this.firebaseUser = authResult.user;
              _saveUserData(user);
              getAllUserData();
              updatePartnerData();
              isLogged = true;
              saveToken();
              onSuccess();
              isLoading = false;
              notifyListeners();
            }
          }
          break;
        case FacebookLoginStatus.cancelledByUser:
          isLogged = false;
          isLoading = false;
          notifyListeners();
          break;
        case FacebookLoginStatus.error:
          errorSignFacebook = true;
          isLogged = false;
          isLoading = false;
          notifyListeners();
          break;
      }
    } catch (e) {
      print(e);
      onFail();
      isLogged = false;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(
      {@required User user,
      @required Function onSuccess,
      @required Function onFail}) async {
    isLoading = true;
    notifyListeners();
    try {
      final AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      this.firebaseUser = result.user;
      await _saveUserData(user);
      onSuccess();
      updatePartnerData();
      getAllUserData();
      isLogged = true;
      saveToken();
      isLoading = false;
      notifyListeners();
    } on PlatformException catch (_) {
      onFail();
      isLogged = false;
      isLoading = false;
      notifyListeners();
    }
  }

  void signOut() async {
    isLoading = true;
    notifyListeners();
    await _auth.signOut();
    userData = Map();
    addresses.clear();
    creditDebitCardList.clear();
    categoryDataList.clear();
    storeDataList.clear();
    storeDataListClosed.clear();
    storeListFavorites.clear();
    listUserOrders.clear();
    listPartnerOders.clear();
    lastPurchasedStores.clear();
    firebaseUser = null;
    isLogged = false;
    isLoading = false;
    updatePartnerData();
    notifyListeners();
  }

  Future<Null> _saveUserData(User user) async {
    userData["name"] = user.name;
    userData["email"] = user.email;
    userData["isPartner"] = 3;
    userData["image"] = "https://meuvidraceiro.com.br/images/sem-imagem.png";
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  void _getCurrentLocation() async {
    isLoading = true;
    notifyListeners();
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      final postition =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (postition.latitude != null) {
        latitude = postition.latitude;
      }
      if (postition.longitude != null) {
        longittude = postition.longitude;
      }
    }
    isLoading = false;
    notifyListeners();
  }

  void _loadCurrentUser() async {
    isLoading = true;
    notifyListeners();
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
        userName = userData["name"];
        userImage = userData["image"];
        isPartner = userData["isPartner"];
        if (userData["storeId"] != null) {
          await Firestore.instance
              .collection("stores")
              .document(userData["storeId"])
              .get()
              .then((doc) {
            if (doc.exists) {
              final storeDocument = StoreData.fromDocument(doc);
              storeData = storeDocument;
            }
          });
        }
        if (userData["currentAddress"] != null) {
          currentUserId = userData["currentAddress"];
          try {
            await Firestore.instance
                .collection("users")
                .document(firebaseUser.uid)
                .collection("address")
                .document(currentUserId)
                .get()
                .then((doc) {
              if (doc.exists) {
                final userAddress = AddressData.fromDocument(doc);
                currentUserAddress = userAddress;
                addressSeted = true;
              } else {
                currentUserAddress.aid = "";
                currentUserAddress.city = "";
                currentUserAddress.street = "";
                addressSeted = false;
              }
            });
          } catch (e) {}
        } else {}
      }
      getAllUserData();
    }

    isLoading = false;
    notifyListeners();
  }

  void getAllUserData() async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      try {
        QuerySnapshot querySnapshot =
            await Firestore.instance.collection("stores").getDocuments();
        storeDataList.clear();
        storeDataListOpened.clear();
        storeDataListClosed.clear();
        querySnapshot.documents.map((doc) {
          StoreData storeData = StoreData.fromDocument(doc);
          storeDataList.add(StoreData.fromDocument(doc));
          if (storeData.isStoreOpen) {
            storeDataListOpened.add(StoreData.fromDocument(doc));
          } else {
            storeDataListClosed.add(StoreData.fromDocument(doc));
          }
        }).toList();
      } catch (e) {}
      if (storeDataList.length > 0) hasStories = true;
      try {
        QuerySnapshot query = await Firestore.instance
            .collection("orders")
            .orderBy('createdAt', descending: true)
            .getDocuments();
        listUserOrders.clear();
        purchasedsProducts.clear();
        query.documents.map((doc) {
          if (doc.data["client"] == firebaseUser.uid) {
            listUserOrders.add(OrderData.fromDocument(doc));
            updatedPurchasedProducts(doc);
          }
        }).toList();
      } catch (erro) {}
      try {
        lastPurchasedStores.clear();
        for (OrderData order in listUserOrders) {
          bool hasStoreinList = false;
          if (lastPurchasedStores.length == 0) {
            for (StoreData storesVeryfication in storeDataList) {
              if (storesVeryfication.id == order.storeId) {
                lastPurchasedStores.add(
                    StoreData.fromDocument(storesVeryfication.storeSnapshot));
              }
            }
          } else {
            for (StoreData storeFlagVeryFicatrion in lastPurchasedStores) {
              if (storeFlagVeryFicatrion.id == order.storeId) {
                hasStoreinList = true;

                break;
              }
            }
            if (!hasStoreinList) {
              for (StoreData storesVeryfication in storeDataList) {
                if (storesVeryfication.id == order.storeId) {
                  if (storesVeryfication.id == order.storeId) {
                    lastPurchasedStores.add(StoreData.fromDocument(
                        storesVeryfication.storeSnapshot));
                  }
                }
              }
            }
          }
        }
        notifyListeners();
      } catch (erro) {
        notifyListeners();
      }
    }
  }

  Future<void> getAddressFromZipCode(String zipCode) async {
    isLoading = true;
    notifyListeners();
    final cleanedCep = zipCode.replaceAll('.', '').replaceAll('-', '');
    final endPoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanedCep";
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';
    try {
      final response = await dio.get<Map<String, dynamic>>(endPoint);
      if (response.data.isEmpty) {
        return Future.error('CEP Inválido');
      }
      try {
        final cepAbertoAddress = CepAbertoAddress.fromMap(response.data);
        if (cepAbertoAddress != null) {
          street = cepAbertoAddress.logradouro;
          state = cepAbertoAddress.state.sigla;
          zipCode = cepAbertoAddress.cep;
          district = cepAbertoAddress.bairro;
          city = cepAbertoAddress.city.nome;
        } else {
          return 'null ZipCode';
        }
      } catch (e) {}
    } on DioError {
      //return Future.error("Erro ao buscar CEP" + e.toString());
    }
    isLoading = false;
    notifyListeners();
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
      final cepAbertoAddress = CepAbertoAddress.fromMap(response.data);
      if (cepAbertoAddress != null) {
        street = cepAbertoAddress.logradouro;
        state = cepAbertoAddress.state.sigla;
        zipCode = cepAbertoAddress.cep;
        district = cepAbertoAddress.bairro;
        city = cepAbertoAddress.city.nome;
      }
    } on DioError {}
    isLoading = false;
    notifyListeners();
  }

  void addAddress(Address address) async {
    final addressData = AddressData.fromAddress(address);
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .collection('address')
        .add({
      'name': address.name,
      'zipCode': address.zipCode,
      'street': address.street,
      'number': address.number,
      'complement': address.complement,
      'district': address.district,
      'city': address.city,
      "state": address.state,
      "latitude": address.latitude,
      "longitude": address.longitude
    }).then((doc) {
      if (doc.documentID != null) {
        address.aid = doc.documentID;
        addressData.aid = doc.documentID;
      } else {
        address.aid = '';
        addressData.aid = '';
      }
    });
    addresses.add(addressData);
    isLoading = false;
    notifyListeners();
  }

  void loadAddressItems() async {
    try {
      QuerySnapshot query = await Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .collection("address")
          .getDocuments();
      addresses =
          query.documents.map((doc) => AddressData.fromDocument(doc)).toList();
      if (addresses.isEmpty) {
        addressSeted = false;
      }
    } catch (e) {}
    notifyListeners();
  }

  void setUserAddress(AddressData address) async {
    isLoading = true;
    notifyListeners();
    userData["currentAddress"] = address.aid;
    userData["address"] = address.toMap();
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .updateData(userData);
    currentUserAddress = address;
    addressSeted = true;
    isLoading = false;
    notifyListeners();
  }

  void newCard(CreditDebitCard creditDebitCard) async {
    isLoading = true;
    notifyListeners();
    final creditDebitCardData =
        CreditDebitCardData.fromCreditDebitCardItem(creditDebitCard);
    await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
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
      if (doc.documentID != null) {
        creditDebitCardData.cardId = doc.documentID;
        creditDebitCardList.add(creditDebitCardData);
      } else {
        creditDebitCardData.cardId = "";
      }
    });
    isLoading = false;
    notifyListeners();
  }

  void _loadListCreditDebitCard() async {
    try {
      if (firebaseUser == null) firebaseUser = await _auth.currentUser();
      if (firebaseUser != null) {
        QuerySnapshot query = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .collection("paymentForms")
            .getDocuments();
        creditDebitCardList = query.documents
            .map((documentSnapshot) =>
                CreditDebitCardData.fromDocument(documentSnapshot))
            .toList();
      }
    } catch (e) {}
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

  void setPaymentOnDeliveryMethod(PaymentOnDeliveryData paymentOnDeliveryData) {
    isLoading = true;
    notifyListeners();
    paymentSet = true;
    currentPaymentOndeliveryData = paymentOnDeliveryData;
    payOnApp = false;
    isLoading = false;
    notifyListeners();
  }

  void saveToken() async {
    final token = await FirebaseMessaging().getToken();
    await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .collection("tokens")
        .document(token)
        .setData({
      'token': token,
      'updateAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem
    });
  }

  Future<void> createNewStoreWithCPF({
    @required File imageFile,
    @required StoreCPF storeCPF,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();
    String url;
    try {
      if (firebaseUser == null) await _auth.currentUser();
      if (firebaseUser != null) {
        if (imageFile == null) {
          url = "https://meuvidraceiro.com.br/images/sem-imagem.png";
        } else {
          StorageUploadTask task = FirebaseStorage.instance
              .ref()
              .child("images")
              .child(DateTime.now().millisecond.toString())
              .putFile(imageFile);
          StorageTaskSnapshot taskSnapshot = await task.onComplete;
          url = await taskSnapshot.ref.getDownloadURL();
        }
        await Firestore.instance.collection("stores").add({
          "partnerId": firebaseUser.uid,
          "title": storeCPF.name,
          "name": storeCPF.name,
          "cpf": storeCPF.cpf,
          "image": url,
          "description": storeCPF.description,
          "isOpen": true,
          "address": {
            "name": "Store Address",
            "zipCode": storeCPF.zipCode,
            "street": storeCPF.street,
            "district": storeCPF.district,
            "number": storeCPF.number,
            "city": storeCPF.city,
            "state": storeCPF.state,
            "image": storeCPF.image,
          }
        }).then((store) async {
          await Firestore.instance
              .collection("users")
              .document(firebaseUser.uid)
              .updateData({
            "storeId": store.documentID,
            "isPartner": 2,
          });
        });
        storeData.name = storeCPF.name;
        storeData.image = storeCPF.description;
        storeData.description = storeCPF.description;
        storeCPF = null;
        onSuccess();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  void createNewProduct({
    @required String productGroup,
    @required File imageFile,
    @required String title,
    @required String description,
    @required String fullDescription,
    @required String price,
    @required String category,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();
    String url;
    try {
      if (imageFile == null) {
        url = "https://meuvidraceiro.com.br/images/sem-imagem.png";
      } else {
        StorageUploadTask task = FirebaseStorage.instance
            .ref()
            .child("images")
            .child(storeData.id + DateTime.now().millisecond.toString())
            .putFile(imageFile);
        StorageTaskSnapshot taskSnapshot = await task.onComplete;
        url = await taskSnapshot.ref.getDownloadURL();
      }
      Firestore.instance
          .collection("stores")
          .document(userData["storeId"])
          .collection("products")
          .add({
        "group": productGroup,
        "title": title,
        "category": category,
        "description": description,
        "fullDescription": fullDescription,
        "image": url,
        "price": double.parse(
          price.replaceAll(",", "."),
        ),
        "storeID": userData["storeId"]
      }).then((value) {});
      onSuccess();
      updatePartnerData();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
      onFail();
    }
  }

  void updateCategory() async {
    isLoading = true;
    notifyListeners();
    try {
      if (firebaseUser == null) firebaseUser = await _auth.currentUser();
      if (firebaseUser != null) {
        QuerySnapshot query =
            await Firestore.instance.collection("categories").getDocuments();
        categoryDataList = query.documents
            .map((doc) => CategoryData.fromDocument(doc))
            .toList();
      }
    } catch (e) {}
    isLoading = false;
    notifyListeners();
  }

  void updateStories() async {
    try {
      if (firebaseUser == null) await _auth.currentUser();
      if (firebaseUser != null) {
        QuerySnapshot querySnapshot =
            await Firestore.instance.collection("stores").getDocuments();
        storeDataList = querySnapshot.documents
            .map((doc) => StoreData.fromDocument(doc))
            .toList();
      }
    } catch (e) {}
    if (storeDataList.length > 0) hasStories = true;
    notifyListeners();
  }

  void updateStoreFavorites() async {
    isLoading = true;
    notifyListeners();
    try {
      if (firebaseUser == null) await _auth.currentUser();
      if (firebaseUser != null) {
        QuerySnapshot querySnapshot = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .collection("favorites")
            .getDocuments();
        querySnapshot.documents.map((doc) async {
          DocumentSnapshot documentSnapshot = await Firestore.instance
              .collection("stores")
              .document(doc.documentID)
              .get();
          storeListFavorites.add(StoreData.fromDocument(documentSnapshot));
        }).toList();
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
    }
  }

  bool verifyFavoriteStore(String storeId) {
    return true;
  }

  void addFavoriteStore(StoreData storeDataFavorite) {
    Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .collection("favorites")
        .document(storeDataFavorite.id)
        .setData(
      {
        "storeId": storeDataFavorite.id,
      },
    );
    storeListFavorites.add(storeDataFavorite);
  }

  void removeFavoriteStore(StoreData storeDataFavorite) {
    Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .collection('favorites')
        .document(storeDataFavorite.id)
        .delete();
    storeListFavorites.remove(storeListFavorites);
  }

  void getUserOrder() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      bool hasStore = false;
      try {} catch (e) {}
      notifyListeners();
    }
  }

  void updatedPurchasedProducts(DocumentSnapshot snapshot) {
    for (LinkedHashMap product in snapshot.data["products"]) {
      bool hasProduct = false;
      final purchasedProduct = ProductData(
        id: product["pid"],
        title: product["productTitle"],
        categoryId: null,
        description: null,
        image: null,
        price: null,
        fullDescription: null,
        group: null,
        storeId: product["storeId"],
      );

      if (purchasedsProducts.length == 0) {
        purchasedsProducts.add(purchasedProduct);
      } else {
        for (ProductData productPurchased in purchasedsProducts) {
          if (purchasedProduct.id == productPurchased.id) {
            hasProduct = true;
            break;
          }
        }
        if (!hasProduct) {
          purchasedsProducts.add(purchasedProduct);
        }
      }
    }
  }

  void getListPurchasedStores() {}
  void updatePartnerData() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      try {
        DocumentSnapshot partnerDocument = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        if (partnerDocument.data["storeId"] != null) {
          listPartnerOders.clear();
          DocumentSnapshot storeDocument = await Firestore.instance
              .collection("stores")
              .document(partnerDocument.data["storeId"])
              .get();
          storeId = storeDocument.documentID;
          storeName = storeDocument.data["title"];
          storeImage = storeDocument.data["image"];
          storeData = StoreData.fromDocument(storeDocument);
          isStoreHourConfigurated = storeData.ishourSeted;
          print(isStoreHourConfigurated);
          QuerySnapshot querySnapshot = await Firestore.instance
              .collection("orders")
              .orderBy('createdAt', descending: true)
              .getDocuments();
          querySnapshot.documents.map((doc) {
            if (doc.data["storeId"] == storeData.id) {
              listPartnerOders.add(
                OrderData.fromDocument(doc),
              );
            }
          }).toList();
          if (listPartnerOders.length > 0) {
            hasPartnerOrders = true;
          }
          QuerySnapshot queryProductSnapshot = await Firestore.instance
              .collection("stores")
              .document(partnerDocument.data["storeId"])
              .collection("products")
              .getDocuments();
          productsStore.clear();
          queryProductSnapshot.documents.map((doc) {
            productsStore.add(ProductData.fromDocument(doc));
          }).toList();

          storesCategoresList.clear();
          QuerySnapshot queryCategories = await Firestore.instance
              .collection("stores")
              .document(storeId)
              .collection("categories")
              .orderBy(
                "order",
                descending: false,
              )
              .getDocuments();
          queryCategories.documents.map((doc) {
            storesCategoresList.add(StoreCategoreData.fromDocument(doc));
          }).toList();
          notifyListeners();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void setChatData(OrderData orderData) {
    chatOrderData = orderData;
    print(chatOrderData.orderId);
    notifyListeners();
  }

  void sendtextMessageByStore(String text) async {
    await Firestore.instance
        .collection("orders")
        .document(chatOrderData.orderId)
        .collection("chat")
        .add({
      "userId": chatOrderData.storeId,
      "text": text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void sendImageMessageByStore(File imageFile) async {
    if (imageFile == null) return;
    StorageUploadTask task = FirebaseStorage.instance
        .ref()
        .child("images")
        .child("chat")
        .child(
          DateTime.now().millisecondsSinceEpoch.toString(),
        )
        .putFile(imageFile);
    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String urlImage = await taskSnapshot.ref.getDownloadURL();
    await Firestore.instance
        .collection("orders")
        .document(chatOrderData.orderId)
        .collection("chat")
        .add({
      "userId": chatOrderData.storeId,
      "image": urlImage,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void sendtextMessageByUser(String text) async {
    await Firestore.instance
        .collection("orders")
        .document(chatOrderData.orderId)
        .collection("chat")
        .add({
      "userId": firebaseUser.uid,
      "text": text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void sendImageMessageByUser(File imageFile) async {
    if (imageFile == null) return;
    StorageUploadTask task = FirebaseStorage.instance
        .ref()
        .child("images")
        .child("chat")
        .child(
          DateTime.now().millisecondsSinceEpoch.toString(),
        )
        .putFile(imageFile);
    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String urlImage = await taskSnapshot.ref.getDownloadURL();
    await Firestore.instance
        .collection("orders")
        .document(chatOrderData.orderId)
        .collection("chat")
        .add({
      "userId": firebaseUser.uid,
      "image": urlImage,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void addNewAddress({
    @required AddressDataFromGoogle addressDataFromGoogle,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    try {
      await Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .collection("addressFromGoogle")
          .getDocuments()
          .then((query) {
        query.documents.map((doc) async {
          await Firestore.instance
              .collection("users")
              .document(firebaseUser.uid)
              .collection("addressFromGoogle")
              .document(doc.documentID)
              .updateData({
            "isDefined": false,
          });
        }).toList();
      });
      await Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .collection("addressFromGoogle")
          .add({
        "descripition": addressDataFromGoogle.description,
        "placeId": addressDataFromGoogle.placeId,
        "reference": addressDataFromGoogle.reference,
        "isDefined": true,
      });
      addressDataFromGoogle.isDefined = true;
      addressDataFromGoogleList.add(addressDataFromGoogle);
      setCurrentAddressFromGoolgle(addressDataFromGoogle);
      onSuccess();
      _loadAddressFromGoogle();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      onFail();
      notifyListeners();
    }
  }

  void setCurrentAddressFromGoolgle(
      AddressDataFromGoogle addressDataFromGoogle) async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      try {
        await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .collection("addressFromGoogle")
            .getDocuments()
            .then((query) {
          query.documents.map((doc) async {
            await Firestore.instance
                .collection("users")
                .document(firebaseUser.uid)
                .collection("addressFromGoogle")
                .document(doc.documentID)
                .updateData({
              "isDefined": false,
            });
          }).toList();
        });
        await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .collection("addressFromGoogle")
            .document(addressDataFromGoogle.id)
            .updateData({
          "isDefined": true,
        });
        currentAddressDataFromGoogle = addressDataFromGoogle;
      } catch (e) {
        print(e);
      }
      notifyListeners();
    }
  }

  void _loadAddressFromGoogle() async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      try {
        addressDataFromGoogleList.clear();
        QuerySnapshot addressQuery = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .collection("addressFromGoogle")
            .getDocuments();
        addressQuery.documents.map((doc) {
          final addressData = AddressDataFromGoogle(
            id: doc.documentID,
            description: doc.data["descripition"],
            placeId: doc.data["placeId"],
            reference: doc.data["reference"],
            isDefined: doc.data["isDefined"],
          );
          if (doc.data["isDefined"]) {
            currentAddressDataFromGoogle = addressData;
            addressSeted = true;
          }
          addressDataFromGoogleList.add(addressData);
        }).toList();
        notifyListeners();
      } catch (e) {
        print("erro");
        print(e.toString());
        notifyListeners();
      }
    }
  }

  void editProduct({
    @required ProductData productData,
    @required File imageFile,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required String categoryId,
    @required callOnCategoryNull,
  }) async {
    if (categoryId == null) {
      callOnCategoryNull();
      return;
    }
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      isLoading = true;
      notifyListeners();
      try {
        if (imageFile != null) {
          StorageUploadTask task = FirebaseStorage.instance
              .ref()
              .child("images")
              .child("chat")
              .child(
                DateTime.now().millisecondsSinceEpoch.toString(),
              )
              .putFile(imageFile);
          StorageTaskSnapshot taskSnapshot = await task.onComplete;
          String urlImage = await taskSnapshot.ref.getDownloadURL();
          await Firestore.instance
              .collection("stores")
              .document(storeId)
              .collection("products")
              .document(productData.id)
              .updateData({
            "title": productData.title,
            "image": urlImage,
            "categoryId": productData.categoryId,
            "description": productData.description,
            "fullDescription": productData.fullDescription,
            "group": productData.group,
            "price": productData.price,
          });
          QuerySnapshot queryProductSnapshot = await Firestore.instance
              .collection("stores")
              .document(storeId)
              .collection("products")
              .getDocuments();
          productsStore.clear();
          queryProductSnapshot.documents.map((doc) {
            productsStore.add(ProductData.fromDocument(doc));
          }).toList();
          onSuccess();
          isLoading = false;
          notifyListeners();
        } else {
          await Firestore.instance
              .collection("stores")
              .document(storeId)
              .collection("products")
              .document(productData.id)
              .updateData({
            "title": productData.title,
            "categoryId": productData.categoryId,
            "description": productData.description,
            "fullDescription": productData.fullDescription,
            "group": productData.group,
            "price": productData.price,
          });
          QuerySnapshot queryProductSnapshot = await Firestore.instance
              .collection("stores")
              .document(storeId)
              .collection("products")
              .getDocuments();
          productsStore.clear();
          queryProductSnapshot.documents.map((doc) {
            productsStore.add(ProductData.fromDocument(doc));
          }).toList();
          onSuccess();
          isLoading = false;
          notifyListeners();
        }
      } catch (e) {
        onFail();
        isLoading = false;
        notifyListeners();
      }
    }
  }

  void insertOptIncrement({
    @required File imageFile,
    @required IncrementalOptData incrementalOptData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      isLoading = true;
      notifyListeners();
      try {
        await Firestore.instance
            .collection("stores")
            .document(storeId)
            .collection("products")
            .document(incrementalOptData.productId)
            .collection("incrementalOptions")
            .add(
              incrementalOptData.toIncrementalMap(),
            );
        onSuccess();
        updateIncrementalProductOptions();
        getIncrementalsFromProduct(incrementalOptData.productId);
        isLoading = false;
        notifyListeners();
      } catch (e) {
        onFail();
        isLoading = false;
        notifyListeners();
      }
    }
  }

  void updateIncrementalProductOptions() async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      try {
        QuerySnapshot querySnapshot = await Firestore.instance
            .collection("stores")
            .document(storeId)
            .collection("products")
            .getDocuments();
        incrementalOptDataList.clear();
        querySnapshot.documents.map((doc) async {
          QuerySnapshot queryIncrementalSnapshot = await Firestore.instance
              .collection("stores")
              .document(storeId)
              .collection("products")
              .document(doc.documentID)
              .collection("incrempentalOptions")
              .getDocuments();
          queryIncrementalSnapshot.documents.map((doc) {
            incrementalOptDataList.add(IncrementalOptData.fromDocument(doc));
          }).toList();
        }).toList();
      } catch (e) {}
    }
  }

  void insertNewOptOnlyChoose({
    @required IncrementalOptData incrementalOptData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    print("ok");
    bool alereadySeccion = false;
    List<DocumentSnapshot> productDocs = [];
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      isLoading = true;
      notifyListeners();
      print("1");
      try {
        QuerySnapshot querySnapshot = await Firestore.instance
            .collection("stores")
            .document(storeId)
            .collection("products")
            .document(incrementalOptData.productId)
            .collection("onlyChooseOptions")
            .getDocuments();
        productDocs.clear();
        querySnapshot.documents.map((doc) {
          productDocs.add(doc);
        }).toList();
        print(productDocs.length);
        for (DocumentSnapshot doc in productDocs) {
          if (doc.data["secao"] == incrementalOptData.session) {
            await Firestore.instance
                .collection("stores")
                .document(storeId)
                .collection("products")
                .document(incrementalOptData.productId)
                .collection("onlyChooseOptions")
                .document(doc.documentID)
                .collection("itens")
                .add(
                  incrementalOptData.toIncrementalMap(),
                );

            alereadySeccion = true;
          }
        }
        if (!alereadySeccion) {
          await Firestore.instance
              .collection("stores")
              .document(storeId)
              .collection("products")
              .document(incrementalOptData.productId)
              .collection("onlyChooseOptions")
              .add({
            "secao": incrementalOptData.session,
          }).then((doc) async {
            await Firestore.instance
                .collection("stores")
                .document(storeId)
                .collection("products")
                .document(incrementalOptData.productId)
                .collection("onlyChooseOptions")
                .document(doc.documentID)
                .updateData({
              "id": doc.documentID,
            });
            await Firestore.instance
                .collection("stores")
                .document(storeId)
                .collection("products")
                .document(incrementalOptData.productId)
                .collection("onlyChooseOptions")
                .document(doc.documentID)
                .collection("itens")
                .add(
                  incrementalOptData.toIncrementalMap(),
                );
          });
        }
        onSuccess();
        isLoading = false;
        notifyListeners();
      } catch (e) {
        print(e);
        onFail();
        isLoading = false;
        notifyListeners();
      }
    }
  }

  void getIncrementalsFromProduct(String productID) async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      isLoading = true;
      notifyListeners();
      try {
        QuerySnapshot query = await Firestore.instance
            .collection("stores")
            .document(storeId)
            .collection("products")
            .document(productID)
            .collection("incrementalOptions")
            .getDocuments();
        productIncrementals.clear();
        query.documents.map((doc) {
          productIncrementals.add(IncrementalOptData.fromDocument(doc));
        }).toList();
        isLoading = false;
        notifyListeners();
      } catch (e) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  void registerNewCategory({
    @required StoreCategoreData storeCategoreData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required VoidCallback noSize,
    @required int x,
    @required int y,
    @required int order,
  }) async {
    print(order);
    print(storesCategoresList.length);
    if (x == null || y == null) {
      noSize();
      return;
    }
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      isLoading = true;
      notifyListeners();
      String url;
      try {
        if (storeCategoreData.imageFile != null) {
          StorageUploadTask task = FirebaseStorage.instance
              .ref()
              .child("images")
              .child(storeData.id + DateTime.now().millisecond.toString())
              .putFile(storeCategoreData.imageFile);
          StorageTaskSnapshot taskSnapshot = await task.onComplete;
          url = await taskSnapshot.ref.getDownloadURL();
        } else {
          url = storeCategoreData.image;
        }
        await Firestore.instance
            .collection("stores")
            .document(storeId)
            .collection("categories")
            .add({
          "title": storeCategoreData.title,
          "description": storeCategoreData.description,
          "image": url,
          "x": x,
          "y": y,
          "order": order,
        });
        for (var i = order; i < storesCategoresList.length; i++) {
          int pos = i + 1;
          await Firestore.instance
              .collection("stores")
              .document(storeId)
              .collection("categories")
              .document(storesCategoresList[i].id)
              .updateData({
            "order": pos,
          });
        }
        storesCategoresList.clear();
        QuerySnapshot queryCategories = await Firestore.instance
            .collection("stores")
            .document(storeId)
            .collection("categories")
            .orderBy(
              "order",
              descending: false,
            )
            .getDocuments();
        queryCategories.documents.map((doc) {
          storesCategoresList.add(StoreCategoreData.fromDocument(doc));
        }).toList();
        isLoading = false;
        onSuccess();
        notifyListeners();
      } catch (e) {
        print(e);
        isLoading = false;
        notifyListeners();
        onFail();
      }
    }
  }

  void updateStoreCategore({
    @required StoreCategoreData storeCategoreData,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      String url;
      isLoading = true;
      notifyListeners();
      try {
        if (storeCategoreData.imageFile != null) {
          StorageUploadTask task = FirebaseStorage.instance
              .ref()
              .child("images")
              .child(storeData.id + DateTime.now().millisecond.toString())
              .putFile(storeCategoreData.imageFile);
          StorageTaskSnapshot taskSnapshot = await task.onComplete;
          url = await taskSnapshot.ref.getDownloadURL();
        } else {
          url = storeCategoreData.image;
        }
        for (var i = storeCategoreData.order;
            i < storesCategoresList.length;
            i++) {
          int pos = i + 1;
          print(storesCategoresList[i].id);
          await Firestore.instance
              .collection("stores")
              .document(storeId)
              .collection("categories")
              .document(storesCategoresList[i].id)
              .updateData({
            "order": pos,
          });
        }
        await Firestore.instance
            .collection("stores")
            .document(storeId)
            .collection("categories")
            .document(storeCategoreData.id)
            .updateData({
          "description": storeCategoreData.description,
          "title": storeCategoreData.title,
          "image": url,
          "x": storeCategoreData.x,
          "y": storeCategoreData.y,
          "order": storeCategoreData.order,
        });

        storesCategoresList.clear();
        QuerySnapshot queryCategories = await Firestore.instance
            .collection("stores")
            .document(storeId)
            .collection("categories")
            .orderBy(
              "order",
              descending: false,
            )
            .getDocuments();
        queryCategories.documents.map((doc) {
          storesCategoresList.add(StoreCategoreData.fromDocument(doc));
        }).toList();
        onSuccess();
        isLoading = false;
        notifyListeners();
      } catch (erro) {
        onFail();
        print(erro);
        isLoading = false;
        notifyListeners();
      }
    }
  }

  void insertNewOffSale({
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
    @required SalesOffData salesOffData,
  }) async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      String url;
      isLoading = true;
      notifyListeners();
      try {
        if (salesOffData.imageFile != null) {
          StorageUploadTask task = FirebaseStorage.instance
              .ref()
              .child("images")
              .child(storeData.id + DateTime.now().millisecond.toString())
              .putFile(salesOffData.imageFile);
          StorageTaskSnapshot taskSnapshot = await task.onComplete;
          url = await taskSnapshot.ref.getDownloadURL();
        } else {
          url = "https://meuvidraceiro.com.br/images/sem-imagem.png";
        }
        await Firestore.instance
            .collection("stores")
            .document(storeId)
            .collection("off")
            .add({
          "title": salesOffData.title,
          "image": url,
          "description": salesOffData.description,
          "products": salesOffData.products.map((product) {
            return {
              "title": product.title,
              "description": product.description,
              "id": product.id,
              "price": product.price,
              "image": product.image,
            };
          }).toList()
        });
        updateSalesOffList();
        onSuccess();
        isLoading = false;
        notifyListeners();
      } catch (erro) {
        onFail();
        isLoading = false;
        notifyListeners();
      }
    }
  }

  void updateSalesOffList() async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      try {
        salesOffList.clear();
        QuerySnapshot querySnapshot = await Firestore.instance
            .collection("stores")
            .document(storeId)
            .collection("off")
            .getDocuments();
        querySnapshot.documents.map((doc) {
          salesOffList.add(SalesOffData.fromDocument(doc));
        }).toList();
      } catch (e) {}
    }
  }

  void getPurchasedProductsListByStore(String purchasedStoreId) async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      purchasedProductsByStore.clear();
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection("stores")
          .document(purchasedStoreId)
          .collection("products")
          .getDocuments();
      querySnapshot.documents.map((doc) {
        for (ProductData purchasedProduct in purchasedsProducts) {
          if (doc.documentID == purchasedProduct.id) {
            purchasedProductsByStore.add(doc);
          }
        }
      }).toList();
    }
    notifyListeners();
  }

  void verifyOffSales(String storeIdtoVerifyt) async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection("stores")
          .document(storeIdtoVerifyt)
          .collection("off")
          .getDocuments();
      if (querySnapshot.documents.length > 0) {
        hasSalesOff = true;
      } else {
        hasSalesOff = false;
      }
    }
    notifyListeners();
  }

  void veryIfExistsProducts() async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      try {
        productsInCart.clear();
        QuerySnapshot querySnapshot = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .collection("cart")
            .getDocuments();
        if (querySnapshot.documents.length > 0) {
          querySnapshot.documents.map((doc) {
            productsInCart.add(CartProduct.fromDocument(doc));
          }).toList();
          hasProductInCart = true;
        } else {
          productsInCart = [];
          hasProductInCart = false;
        }
      } catch (e) {}
      notifyListeners();
    }
  }

  void updateStoreHours({
    @required int openingTimeHour,
    @required int openingTimeMinute,
    @required int closingTimeHour,
    @required int closingTimeMinute,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      try {
        await Firestore.instance
            .collection("stores")
            .document(storeId)
            .updateData({
          "openingTime": {
            "hour": openingTimeHour,
            "minute": openingTimeMinute,
          },
          "closingTime": {
            "hour": closingTimeHour,
            "minute": closingTimeMinute,
          },
        });
        isStoreHourConfigurated = true;
        onSuccess();
        notifyListeners();
      } catch (e) {
        onFail();
        print(e.toString());
      }
    }
  }

  void removeCartItem({
    @required CartProduct cartProduct,
    @required VoidCallback onSuccess,
    @required VoidCallback onFail,
  }) async {
    if (firebaseUser == null) await _auth.currentUser();
    if (firebaseUser != null) {
      try {
        Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .collection("cart")
            .document(cartProduct.cId)
            .delete();
        productsInCart.remove(cartProduct);
        if (productsInCart.length > 0) {
          hasProductInCart = true;
        } else {
          productsInCart = [];
          hasProductInCart = false;
        }
        onSuccess();
        notifyListeners();
      } catch (erro) {
        onFail();
        notifyListeners();
      }
    }
  }
}
