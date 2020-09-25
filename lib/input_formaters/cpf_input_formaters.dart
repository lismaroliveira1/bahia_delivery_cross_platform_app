import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/services.dart';

class CPFTextFormatter extends TextInputFormatter {
  String cpf;
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    cpf = CPF.format(newValue.text);
    return TextEditingValue(
      text: cpf,
      selection: newValue.selection,
    );
  }
}
