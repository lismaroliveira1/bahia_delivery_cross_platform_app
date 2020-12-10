import 'package:bd_app_full/data/combo_data.dart';
import 'package:bd_app_full/tabs/edit_combo_tab.dart';
import 'package:flutter/material.dart';

class EditComboScreen extends StatelessWidget {
  final ComboData comboData;
  EditComboScreen(this.comboData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: EditComboTab(comboData));
  }
}
