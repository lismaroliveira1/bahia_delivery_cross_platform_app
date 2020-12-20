import 'package:bd_app_full/data/credit_debit_card_data.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';

class CieloPayment {
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  void authorized({
    @required CreditDebitCardData creditDebitCardData,
    @required double price,
  }) async {
    print(price.toString());
    final Map<String, dynamic> dataSale = {
      'merchantOrderId': randomNumeric(10),
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
    print(response.data);
  }
}
