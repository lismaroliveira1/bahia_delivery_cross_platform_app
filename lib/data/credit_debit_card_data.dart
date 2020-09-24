import 'package:flutter/material.dart';

class CreditDebitCard {
  String cardNumber;
  String cardOwnerName;
  String validateDate;
  String cpf;
  String cvv;
  CreditDebitCard(
      {@required this.cardNumber,
      @required this.cardOwnerName,
      @required this.validateDate,
      @required this.cpf,
      @required this.cvv});
}
