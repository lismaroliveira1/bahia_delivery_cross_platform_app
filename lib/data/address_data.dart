import 'package:dio/dio.dart';

class AdressData {
  double altitude;
  String zipCode;
  double longitude;
  double latitude;
  String street;
  String city;
  String state;
  String district;
  String complement;

  AdressData.fromResponse(Response<Map<String, dynamic>> response) {
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
