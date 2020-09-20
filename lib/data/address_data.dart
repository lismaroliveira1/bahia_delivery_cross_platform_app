import 'package:bahia_delivery/models/adress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressData {
  String aid;
  String name;
  String zipCode;
  double latitude;
  double longitude;
  String number; //TODO converter number para int
  String street;
  String district;
  String city;
  String state;
  String complement;

  AddressData.fromAdress(Address address) {
    name = address.name;
    zipCode = address.zipCode;
    latitude = address.latitude;
    longitude = address.longitude;
    number = address.number;
    street = address.street;
    district = address.district;
    city = address.city;
    state = address.state;
    complement = address.complement;
  }
  AddressData.fromDocument(DocumentSnapshot documentSnapshot) {
    aid = documentSnapshot.documentID;
    name = documentSnapshot.data["name"];
    zipCode = documentSnapshot.data["zipCode"];
    latitude = documentSnapshot.data["latitude"];
    longitude = documentSnapshot.data["longitude"];
    number = documentSnapshot.data["number"];
    street = documentSnapshot.data["street"];
    district = documentSnapshot.data["district"];
    city = documentSnapshot.data["city"];
    state = documentSnapshot.data["state"];
    complement = documentSnapshot.data["complement"];
  }
  Map<String, dynamic> toMap() {
    return {
      "aid": aid,
      "name": name,
      "zipCode": zipCode,
      "latitude": latitude,
      "longitude": longitude,
      "number": number,
      "street": street,
      "district": district,
      "city": city,
      "state": state,
      "complement": complement
    };
  }
}
