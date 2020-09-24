import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/services.dart';

class CPFTextFormatter extends TextInputFormatter {
  @override
  String cpf;
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    cpf = CPF.format(newValue.text);
    return TextEditingValue(
      text: cpf,
      selection: newValue.selection,
    );
  }
}
