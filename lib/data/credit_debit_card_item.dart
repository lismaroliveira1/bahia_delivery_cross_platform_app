import 'package:flutter/material.dart';

class CreditDebitCard {
  String cardNumber;
  String cardOwnerName;
  String validateDate;
  String cpf;
  String cvv;
  String image;
  CreditDebitCard({
    @required this.cardNumber,
    @required this.cardOwnerName,
    @required this.validateDate,
    @required this.cpf,
    @required this.cvv,
    @required this.image,
  });
}
