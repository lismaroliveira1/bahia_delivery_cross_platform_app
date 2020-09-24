import 'dart:async';

class CredirCardValidators {
  final validateCardNumber = StreamTransformer<String, String>.fromHandlers(
    handleData: (cardNumber, sink) {
      if (cardNumber.length > 8) {
        sink.add(cardNumber);
      } else {
        sink.addError("Número de cartão inválido");
      }
    },
  );
  final validateOwnerNameCard = StreamTransformer<String, String>.fromHandlers(
      handleData: (ownerNameCard, sink) {
    if (ownerNameCard.length > 1 || ownerNameCard.contains(" ")) {
      sink.add(ownerNameCard);
    } else {
      sink.addError("Nome inválido");
    }
  });
  final validateDate =
      StreamTransformer<String, String>.fromHandlers(handleData: (date, sink) {
    if (date.length > 3) {
      sink.add(date);
    } else {
      sink.addError("Data de Expiração inválida");
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
    if (cpf.length > 11) {
      sink.add(cpf);
    } else {
      sink.addError("CPF Inválido");
    }
  });
}
