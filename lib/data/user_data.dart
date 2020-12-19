import 'package:bd_app_full/data/address_data.dart';
import 'package:bd_app_full/data/delivery_man_data.dart';
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
}
