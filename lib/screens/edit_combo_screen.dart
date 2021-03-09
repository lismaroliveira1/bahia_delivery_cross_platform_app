import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

class EditComboScreen extends StatelessWidget {
  final ComboData comboData;
  EditComboScreen(this.comboData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: EditComboTab(comboData));
  }
}
