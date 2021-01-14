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
  LatLng latLng;
  String deliveryManId;
  DeliveryManData userDeliveryMan;
  String uid;
  int storeClosingTimeHour;
  int storeClosingTimeMinute;
  int storeOpeningTimeHour;
  int storeOpeningTimeMinute;

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
    this.latLng,
    this.deliveryManId,
    this.userDeliveryMan,
    this.uid,
  });
  UserData.fromDocumentSnapshot(DocumentSnapshot docUser) {
    uid = name = docUser.get("name");
    email = docUser.get("email");
    image = docUser.get("image");
    isPartner = docUser.get("isPartner");
    if (isPartner == 1) {
      storeId = docUser.get("storeId");
    } else if (isPartner == 6) {
      deliveryManId = docUser.get("deliveryManId");
    }
  }
}
