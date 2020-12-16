import 'package:flutter/cupertino.dart';

class RequestPartnerData {
  String ownerName;
  String cpf;
  String cnpj;
  DateTime birthDay;
  String storeAddress;
  RequestPartnerData({
    @required this.ownerName,
    @required this.birthDay,
    this.cnpj,
    this.cpf,
    @required this.storeAddress,
  });
}
