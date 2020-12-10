import 'package:bd_app_full/data/credit_debit_card_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentFormData {
  CreditDebitCardData creditDebitCardData;
  String type;
  String paymentFormId;

  PaymentFormData.fromQuerydocs(QueryDocumentSnapshot queryDoc) {
    paymentFormId = queryDoc.id;
    type = type;
    creditDebitCardData = CreditDebitCardData.fromQueryDocument(queryDoc);
  }
}
