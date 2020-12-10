import 'package:bd_app_full/data/credit_debit_card_data.dart';
import 'package:bd_app_full/data/user_data.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';

class CieloPayment {
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  void authorized(
      {@required CreditDebitCardData creditDebitCardData,
      @required num price,
      @required String orderId,
      @required UserData user}) async {
    final Map<String, dynamic> dataSale = {
      'merchantOrderId': orderId,
      'amount': (100 * price).toInt(),
      'softDescriptor': 'Bahia Delivery',
      'installments': 1,
      'creditCard': creditDebitCardData.toJson(),
      'cpf': creditDebitCardData.cpf,
      'paymentType': 'CreditCard',
    };
    final HttpsCallable callable =
        functions.httpsCallable('authorizeCreditCard');
    final response = await callable.call(dataSale);
    print(response.data);
  }
}
