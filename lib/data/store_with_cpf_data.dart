import 'package:flutter/cupertino.dart';

class StoreCPF {
  String image;
  String name;
  String cpf;
  String zipCode;
  String street;
  String district;
  String number;
  String city;
  String state;
  StoreCPF({
    @required this.name,
    @required this.cpf,
    @required this.zipCode,
    @required this.street,
    @required this.district,
    @required this.number,
    @required this.city,
    @required this.state,
  });
}
