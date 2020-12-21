import 'package:bd_app_full/data/credit_debit_card_Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreditDebitCardData {
  String cardId;
  String cardNumber;
  String cardOwnerName;
  String validateDate;
  String cpf;
  String cvv;
  String image;
  String brand;
  bool isDebit = false;

  CreditDebitCardData.fromCreditDebitCardItem(CreditDebitCard creditDebitCard) {
    cardNumber = creditDebitCard.cardNumber;
    cardOwnerName = creditDebitCard.cardOwnerName;
    validateDate = creditDebitCard.validateDate;
    cpf = creditDebitCard.cpf;
    cvv = creditDebitCard.cvv;
    image = creditDebitCard.image;
    brand = creditDebitCard.brand;
  }

  CreditDebitCardData.fromQueryDocument(
      QueryDocumentSnapshot documentSnapshot) {
    cardId = documentSnapshot.id;
    cardNumber = documentSnapshot.get("cardNumber");
    cardOwnerName = documentSnapshot.get("cardOwnerName");
    validateDate = documentSnapshot.get("validateDate");
    cpf = documentSnapshot.get("cpf");
    cvv = documentSnapshot.get("cvv");
    image = documentSnapshot.get("image");
    brand = documentSnapshot.get("brand");
  }
  CreditDebitCardData.fromDocument(DocumentSnapshot documentSnapshot) {
    cardId = documentSnapshot.id;
    cardNumber = documentSnapshot.get("cardNumber");
    cardOwnerName = documentSnapshot.get("cardOwnerName");
    validateDate = documentSnapshot.get("validateDate");
    cpf = documentSnapshot.get("cpf");
    cvv = documentSnapshot.get("cvv");
    image = documentSnapshot.get("image");
    brand = documentSnapshot.get("brand");
  }
  Map<String, dynamic> toMap() {
    return {
      'cardId': cardId,
      'cardNumber': cardNumber.replaceAll(" ", ""),
      'cardOwnerName': cardOwnerName,
      'validateDate': validateDate,
      'cpf': cpf,
      'cvv': cvv,
      'image': image,
      'brand': brand,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber.replaceAll(" ", ""),
      'holder': cardOwnerName,
      'expirationDate': validateDate,
      'securityCode': cvv,
      'brand': brand,
    };
  }
}
