import 'dart:io';
import 'package:bahia_delivery/data/address_data.dart';
import 'package:bahia_delivery/data/search_data.dart';
import 'package:bahia_delivery/models/adress.dart';
import 'package:bahia_delivery/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scoped_model/scoped_model.dart';

const token = '635289558f18ba4c749d6928e8cd0ba7';

class UserModel extends Model {
  Map<String, dynamic> userData = Map();
  FirebaseUser firebaseUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool isPartner = false;
  double longittude;
  double latitude;
  int favoriteStoryQuantity = 0;
  List<AddressData> addresses = [];
  String street;
  String state;
  String zipCode;
  String district;
  String city;
  AddressData currentUserAddress;
  String currentUserId;
  bool addressSeted = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);
  @override
  void addListener(VoidCallback listener) async {
    super.addListener(listener);
    _loadCurrentUser();
    _getCurrentLocation();
  }

  Future<void> signIn(
      {@required String email,
      @required String pass,
      @required Function onFail,
      @required Function onSuccess}) async {
    isLoading = true;
    notifyListeners();
    try {
      final AuthResult result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      this.firebaseUser = result.user;
      _loadCurrentUser();
      onSuccess();
      isLoading = false;
      notifyListeners();
    } on PlatformException catch (_) {
      onFail();
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
    userData["isPartner"] = user.isPartner;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  bool updateUser() {
    return isPartner;
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
          } catch (e) {
            print(e.toString());
          }
        }
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
    } on DioError catch (e) {
      print(e.toString());
    }
    isLoading = false;
    notifyListeners();
  }

  void addAddress(Address address) async {
    final addressData = AddressData.fromAdress(address);
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
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .updateData(userData);
    currentUserAddress = address;
    addressSeted = true;
    isLoading = false;
    notifyListeners();
  }
}
