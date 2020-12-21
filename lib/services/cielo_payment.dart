import 'package:bd_app_full/data/credit_debit_card_data.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';

class CieloPayment {
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  dynamic authorized({
    @required CreditDebitCardData creditDebitCardData,
    @required double price,
  }) async {
    print(price.toString());
    final Map<String, dynamic> dataSale = {
      'merchantOrderId': randomAlphaNumeric(20),
      'amount': (100 * price).toInt(),
      'softDescriptor': 'Bahia Delivery',
      'installments': 1,
      'creditCard': creditDebitCardData.toJson(),
      'cpf': creditDebitCardData.cpf,
      'paymentType': 'CreditCard',
    };
    final HttpsCallable callable =
        functions.httpsCallable('authorizedCreditCard');
    final response = await callable.call(dataSale);
    return response.data;
  }

  dynamic authorizedDebitCard({
    @required CreditDebitCardData creditDebitCardData,
    @required double price,
  }) async {
    final Map<String, dynamic> dataSale = {
      'merchantOrderId': randomAlphaNumeric(20),
      'amount': (100 * price).toInt(),
      'softDescriptor': 'Bahia Delivery',
      'installments': 1,
      'creditCard': creditDebitCardData.toJson(),
      'cpf': creditDebitCardData.cpf,
      'paymentType': 'DeditCard',
    };
    final HttpsCallable callable =
        functions.httpsCallable('authorizedDebitCard');
    final response = await callable.call(dataSale);
    print(response.data);
    return response.data;
  }
}
