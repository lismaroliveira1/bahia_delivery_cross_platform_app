import 'package:bahia_delivery/data/credit_debit_card_item.dart';
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

  CreditDebitCardData.fromCreditDebitCardItem(CreditDebitCard creditDebitCard) {
    cardNumber = creditDebitCard.cardNumber;
    cardOwnerName = creditDebitCard.cardOwnerName;
    validateDate = creditDebitCard.validateDate;
    cpf = creditDebitCard.cpf;
    cvv = creditDebitCard.cvv;
    image = creditDebitCard.image;
    brand = creditDebitCard.brand;
  }

  CreditDebitCardData.fromDocument(DocumentSnapshot documentSnapshot) {
    cardId = documentSnapshot.documentID;
    cardNumber = documentSnapshot.data["cardNumber"];
    cardOwnerName = documentSnapshot.data["cardOwnerName"];
    validateDate = documentSnapshot.data["validateDate"];
    cpf = documentSnapshot.data["cpf"];
    cvv = documentSnapshot.data["cvv"];
    image = documentSnapshot.data["image"];
    brand = documentSnapshot.data["brand"];
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
      'secuityCode': cvv,
      'brand': brand,
    };
  }
}
