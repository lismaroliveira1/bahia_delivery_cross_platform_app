import 'dart:async';

class LoginValidators {
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.trim().split(" ").length >= 2) {
      sink.add(name);
    } else {
      sink.addError("Insira nome e sobrenome");
    }
  });
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@")) {
      sink.add(email);
    } else {
      sink.addError("Insira um e-mail válido");
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 4) {
      sink.add(password);
    } else {
      sink.addError("Senha inválida insira uma senha com mais de 4 caracteres");
    }
  });

  final validateConfirmedPassword =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (confimedPassword, sink) {
    if (confimedPassword.length > 4) {
      sink.add(confimedPassword);
    } else {
      sink.addError("Senha inválida insira uma senha com mais de 4 caracteres");
    }
  });
}
