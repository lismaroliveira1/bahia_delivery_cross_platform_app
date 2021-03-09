import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/data.dart';

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
