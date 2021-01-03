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
  String userId;
  String id;
  bool isJuridicPerson;
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
    this.userId,
    this.id,
    this.isJuridicPerson,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "ownerName": ownerName,
      "cpf": cpf,
      "birthday": birthDay,
      "isJuridicPerson": isJuridicPerson,
      "storeDetails": {
        "cnpj": cnpj,
        "image": image,
        "companyName": companyName,
        "expeditionDate": expedtionDate,
        "fantasyName": fantasyName,
        "category": category,
        "categoryId": categoryId,
        "description": description,
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
