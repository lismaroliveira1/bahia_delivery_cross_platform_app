import 'dart:async';

class PartnerSectionValidators {
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.trim().split(" ").length >= 2) {
      sink.add(name);
    } else {
      sink.addError("Insira nome e sobrenome");
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
}
