import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

class EditOffSaleScreen extends StatelessWidget {
  final OffData offData;
  EditOffSaleScreen(this.offData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EditSaleOffTab(offData),
    );
  }
}
