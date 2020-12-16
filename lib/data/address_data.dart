import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AddressData {
  double altitude;
  String zipCode;
  double longitude;
  double latitude;
  String street;
  String city;
  String state;
  String district;
  String complement;
  String country;

  AddressData({
    @required this.altitude,
    @required this.zipCode,
    @required this.longitude,
    @required this.city,
    @required this.complement,
    @required this.district,
    @required this.latitude,
    @required this.state,
    @required this.street,
    this.country,
  });

  AddressData.fromResponse(Response<Map<String, dynamic>> response) {
    altitude = response.data["altitude"];
    zipCode = response.data["cep"];
    longitude = double.parse(response.data["longitude"]);
    latitude = double.parse(response.data["latitude"]);
    city = response.data['cidade']["nome"];
    street = response.data["logradouro"];
    district = response.data["bairro"];
    state = response.data["estado"]["sigla"];
    complement = response.data["complemento"];
  }
}
