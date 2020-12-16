import 'package:bd_app_full/data/address_data.dart';
import 'package:flutter/cupertino.dart';

class RequestPartnerData {
  String ownerName;
  String cpf;
  String cnpj;
  DateTime birthDay;
  AddressData storeAddress;
  RequestPartnerData({
    @required this.ownerName,
    @required this.birthDay,
    this.cnpj,
    this.cpf,
    @required this.storeAddress,
  });
}
