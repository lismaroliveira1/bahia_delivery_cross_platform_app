import 'package:bd_app_full/data/address_data.dart';
import 'package:bd_app_full/data/delivery_man_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geodesy/geodesy.dart';

class UserData {
  String name;
  String email;
  String image;
  String password;
  String confirmPassword;
  String currentAddress;
  int isPartner;
  String storeId;
  String storeAddress;
  String cpf;
  String storeImage;
  String storeName;
  String phoneNumber;
  double latitude;
  double longitude;
  AddressData userAdress;
  LatLng latLng;
  String deliveryManId;
  DeliveryManData userDeliveryMan;
  String uid;

  UserData({
    this.currentAddress,
    this.name,
    this.email,
    this.image,
    this.password,
    this.confirmPassword,
    this.isPartner,
    this.phoneNumber,
    this.storeId,
    this.userAdress,
    this.latLng,
    this.deliveryManId,
    this.userDeliveryMan,
  });
  UserData.fromDocumentSnapshot(DocumentSnapshot docUser) {
    uid = 
    name = docUser.get("name");
    email = docUser.get("email");
    isPartner = docUser.get("isPartner");
    print(isPartner);
    if (isPartner == 1) {
      storeId = docUser.get("isPartner");
    } else if (isPartner == 6) {
      deliveryManId = docUser.get("deliveryManId");
    }
  }
}
