import 'dart:async';
import 'package:cpfcnpj/cpfcnpj.dart';

class RegisterPartnerValidators {
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.trim().split(" ").length >= 2) {
      sink.add(name);
    } else {
      sink.addError("Insira nome e sobrenome");
    }
  });
  final validateFantasyName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 0) {
      sink.add(name);
    } else {
      sink.addError("Nome Fantasia Inválido");
    }
  });
  final validateDescription =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 5) {
      sink.add(name);
    } else {
      sink.addError("Descrição muito curta");
    }
  });
  final validateCPF =
      StreamTransformer<String, String>.fromHandlers(handleData: (cpf, sink) {
    String cpfFormated = CPF.format(cpf);
    if (cpf.length > 11 && CPF.isValid(cpfFormated)) {
      sink.add(cpf);
    } else {
      sink.addError("CPF inválido");
    }
  });

  final validateCNPJ =
      StreamTransformer<String, String>.fromHandlers(handleData: (cnpj, sink) {
    String cpfFormated = CNPJ.format(cnpj);
    if (CNPJ.isValid(cpfFormated)) {
      sink.add(cnpj);
    } else {
      sink.addError("CNPJ inválido");
    }
  });
}
