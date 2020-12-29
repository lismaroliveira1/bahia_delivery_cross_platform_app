import 'dart:async';

class PartnerSectionValidators {
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 0) {
      sink.add(name);
    } else {
      sink.addError("Insira um nome");
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
  final validateLongDescription =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 5) {
      sink.add(name);
    } else {
      sink.addError("Descrição muito curta");
    }
  });
  final validatePrice =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 0) {
      sink.add(name);
    } else {
      sink.addError("Insira um preço váldo");
    }
  });
  final validateDiscount =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 0) {
      sink.add(name);
    } else {
      sink.addError("Insira um disconto");
    }
  });
}
