import 'dart:io';

class DeliveryManData {
  File imageFile;
  String name;
  DateTime birthDay;
  String cpf;
  String location;
  double lat;
  double lng;
  String locationId;
  String image;
  DeliveryManData(
    this.birthDay,
    this.cpf,
    this.imageFile,
    this.lat,
    this.lng,
    this.location,
    this.locationId,
    this.name,
    this.image,
  );

  Map<String, dynamic> toRequestMap() {
    return {
      "name": name,
      "birthDay": birthDay,
      "cpf": cpf,
      "location": location,
      "locationId": locationId,
      "lat": lat,
      "lng": lng,
      "image": image,
    };
  }
}
