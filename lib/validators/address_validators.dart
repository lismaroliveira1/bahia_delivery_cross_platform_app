import 'dart:async';

class AddressValidators {
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length > 1) {
      sink.add(name);
    } else {
      sink.addError("Este campo não pode estar vázio");
    }
  });
  final validateZipCode = StreamTransformer<String, String>.fromHandlers(
      handleData: (zipCode, sink) {
    if (zipCode.length > 8) {
      sink.add(zipCode);
    } else {
      sink.addError("CEP Inválido");
    }
  });
  final validateStreet = StreamTransformer<String, String>.fromHandlers(
      handleData: (street, sink) {
    if (street.length > 1) {
      sink.add(street);
    } else {
      sink.addError("Rua inválida");
    }
  });
  final validateNumber = StreamTransformer<String, String>.fromHandlers(
      handleData: (number, sink) {
    if (number.length >= 1) {
      sink.add(number);
    } else {
      sink.addError("Número Inválido");
    }
  });
  final validateDistrict = StreamTransformer<String, String>.fromHandlers(
      handleData: (disctrict, sink) {
    if (disctrict.length >= 1) {
      sink.add(disctrict);
    } else {
      sink.addError("Bairro Inválido");
    }
  });
  final validateCity =
      StreamTransformer<String, String>.fromHandlers(handleData: (city, sink) {
    if (city.length > 1) {
      sink.add(city);
    } else {
      sink.addError("Cidade Inválida");
    }
  });
  final validateState =
      StreamTransformer<String, String>.fromHandlers(handleData: (state, sink) {
    if (state.length > 1) {
      sink.add(state);
    } else {
      sink.addError("Número Inválido");
    }
  });
}
