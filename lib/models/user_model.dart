import 'dart:io';
import 'package:bahia_delivery/data/address_data.dart';
import 'package:bahia_delivery/data/credit_debit_card_data.dart';
import 'package:bahia_delivery/data/credit_debit_card_item.dart';
import 'package:bahia_delivery/data/payment_on_delivery_date.dart';
import 'package:bahia_delivery/data/search_data.dart';
import 'package:bahia_delivery/data/store_with_cpf_data.dart';
import 'package:bahia_delivery/models/adress.dart';
import 'package:bahia_delivery/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

const token = '635289558f18ba4c749d6928e8cd0ba7';

class UserModel extends Model {
  Map<String, dynamic> userData = Map();
  FirebaseUser firebaseUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  int isPartner = 3;
  double longittude;
  double latitude;
  int favoriteStoryQuantity = 0;
  List<AddressData> addresses = [];
  List<CreditDebitCardData> creditDebitCardList = [];
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

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);
  @override
  void addListener(VoidCallback listener) async {
    super.addListener(listener);
    _loadCurrentUser();
    _getCurrentLocation();
    _loadListCreditDebitCard();
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
      _loadCurrentUser();
      onSuccess();
      saveToken();
      isLoading = false;
      notifyListeners();
    } on PlatformException catch (_) {
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUpWithGoogle({
    @required AuthResult authResult,
  }) async {
    isLoading = true;
    notifyListeners();
    this.firebaseUser = authResult.user;
    DocumentSnapshot docUser = await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .get();
    if (docUser.exists) {
      await _auth.signOut();
      userData = Map();
      firebaseUser = null;
      isLogged = false;
      isLoading = false;
      notifyListeners();
    } else {
      final user = User(
          name: authResult.user.displayName,
          email: authResult.user.email,
          isPartner: false,
          currentAddress: "");
      this.firebaseUser = authResult.user;
      _saveUserData(user);
      isLogged = true;
      saveToken();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading = true;
    notifyListeners();
    isLogged = false;
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
        this.firebaseUser = authResult.user;
        isLogged = true;
        isLoading = false;
        saveToken();
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
      notifyListeners();
    }
  }

  Future<void> signInWithFacebook() async {
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
        break;
      case FacebookLoginStatus.error:
        errorSignFacebook = true;
        isLogged = false;
        isLoading = false;
        notifyListeners();
        break;
    }
  }

  Future<void> signUpWithFacebook() async {
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
            await _auth.signOut();
            userData = Map();
            firebaseUser = null;
            isLogged = false;
            isLoading = false;
            notifyListeners();
          } else {
            final user = User(
                name: authResult.user.displayName,
                email: authResult.user.email,
                isPartner: false,
                currentAddress: "");
            this.firebaseUser = authResult.user;
            _saveUserData(user);
            isLogged = true;
            saveToken();
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
      isLoading = false;
      notifyListeners();
    } on PlatformException catch (_) {
      onFail();
      isLoading = false;
      notifyListeners();
    }
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  Future<Null> _saveUserData(User user) async {
    userData["name"] = user.name;
    userData["email"] = user.email;
    userData["isPartner"] = false;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  bool updateUser() {
    return isPartner != null;
  }

  void _getCurrentLocation() async {
    isLoading = true;
    notifyListeners();
    final postition =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (postition.latitude != null) {
      latitude = postition.latitude;
    }
    if (postition.longitude != null) {
      longittude = postition.longitude;
    }
    latitude = postition.latitude;
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
        isPartner = userData["isPartner"];
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
    }
    isLoading = false;
    notifyListeners();
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
    } on DioError catch (e) {
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
    } on DioError catch (e) {}
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

  void loadAddresstems() async {
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
        .collection('tokens')
        .document(token)
        .setData({
      'token': token,
      'updateAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem
    });
  }

  void createNewStoreWithCPF(StoreCPF storeCPF) async {
    await Firestore.instance.collection("stores").add({
      "title": storeCPF.name,
      "cpf": storeCPF.cpf,
      "image": storeCPF.image,
      "description": storeCPF.description,
      "isOpen": true,
      "address": {
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
  }
}
