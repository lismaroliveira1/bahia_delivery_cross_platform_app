import 'dart:io';

class RequestPartnerData {
  String ownerName;
  String cpf;
  String cnpj;
  String image;
  DateTime birthDay;
  String storeAddress;
  File imageFile;
  String companyName;
  DateTime expedtionDate;
  String location;
  double lat;
  double lng;
  String locationId;
  String closeTime;
  String openTime;
  String category;
  String categoryId;
  String description;
  String fantasyName;
  RequestPartnerData({
    this.ownerName,
    this.birthDay,
    this.cnpj,
    this.cpf,
    this.storeAddress,
    this.companyName,
    this.location,
    this.expedtionDate,
    this.locationId,
    this.closeTime,
    this.imageFile,
    this.lat,
    this.lng,
    this.openTime,
    this.category,
    this.categoryId,
    this.description,
    this.fantasyName,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      "ownerName": ownerName,
      "cpf": cpf,
      "birthday": birthDay,
      "storeDetails": {
        "cnpj": cnpj,
        "image": image,
        "companyName": companyName,
        "openingTime": {
          "closintTime": closeTime,
          "openingTime": openTime,
        },
      },
      "address": {
        "storeAddress": storeAddress,
        "lat": lat,
        "lng": lng,
        "locationId": locationId,
      },
    };
  }
}
