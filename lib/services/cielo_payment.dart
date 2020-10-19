import 'package:bahia_delivery/data/credit_debit_card_data.dart';
import 'package:bahia_delivery/data/user.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';

class CieloPayment {
  final CloudFunctions functions = CloudFunctions.instance;
  void authorized(
      {@required CreditDebitCardData creditDebitCardData,
      @required num price,
      @required String orderId,
      @required User user}) async {
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
        functions.getHttpsCallable(functionName: 'authorizeCreditCard');
    final response = await callable.call(dataSale);
    print(response.data);
  }
}
