import 'dart:async';

import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:credit_card_number_validator/credit_card_number_validator.dart';

class CredirCardValidators {
  final validateCardNumber = StreamTransformer<String, String>.fromHandlers(
    handleData: (cardNumber, sink) {
      Map<String, dynamic> cardData =
          CreditCardValidator.getCard(cardNumber.replaceAll(" ", ""));
      bool isValid = cardData[CreditCardValidator.isValidCard];
      if (isValid) {
        sink.add(cardNumber);
      } else {
        sink.addError("Número de cartão inválido");
      }
    },
  );
  final validateOwnerNameCard = StreamTransformer<String, String>.fromHandlers(
      handleData: (ownerNameCard, sink) {
    if (ownerNameCard.length > 1 && ownerNameCard.contains(" ")) {
      sink.add(ownerNameCard);
    } else {
      sink.addError("Nome inválido");
    }
  });
  final validateDate =
      StreamTransformer<String, String>.fromHandlers(handleData: (date, sink) {
    String error = '';
    switch (date.length) {
      case 1:
        if (int.parse(date) <= 1) {
          sink.add(date);
        } else {
          sink.addError("Més inválido");
        }
        break;
      case 2:
        if (int.parse(date) <= 12) {
          sink.add(date);
        } else {
          sink.addError("Més inválido");
        }
        break;
    }
  });
  final validateCVV = StreamTransformer<String, String>.fromHandlers(
    handleData: (cvv, sink) {
      if (cvv.length < 4) {
        sink.add(cvv);
      } else {
        sink.addError("CVV inválido");
      }
    },
  );
  final validateCPF =
      StreamTransformer<String, String>.fromHandlers(handleData: (cpf, sink) {
    String cpfFormated = CPF.format(cpf);
    if (cpf.length > 11 && CPF.isValid(cpfFormated)) {
      sink.add(cpf);
    } else {
      sink.addError("CPF inválido");
    }
  });
}
