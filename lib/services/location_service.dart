import 'dart:io';

import 'package:bahia_delivery/models/search_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

const token = '635289558f18ba4c749d6928e8cd0ba7';

class SearchAdress {
  Future<void> getAddressFromZipCode(String zipCode) async {
    final cleanedCep = zipCode.replaceAll('.', '').replaceAll('-', '');
    final endPoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanedCep";
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';
    try {
      final response = await dio.get<Map<String, dynamic>>(endPoint);
      if (response.data.isEmpty) {
        return Future.error('CEP Inválido');
      }
      Address.fromMap(response.data);
      print(response.data);
    } on DioError catch (e) {
      return Future.error("Erro ao buscar CEP");
    }
  }

  Future<void> getAddressFromLatLng(
      {@required double lat, @required double lng}) async {
    final endPoint = "https://www.cepaberto.com/api/v3/nearest";
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';
    try {
      final response = await dio.get<Map<String, dynamic>>(endPoint,
          queryParameters: {'lat': lat, 'lng': lng});
      if (response.data.isEmpty) {
        return Future.error('Dados Inválidos');
      }
      Address.fromMap(response.data);
      print(response.data);
    } on DioError catch (e) {}
  }
}
