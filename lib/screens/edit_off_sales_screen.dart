import 'package:bd_app_full/data/offs_data.dart';
import 'package:bd_app_full/tabs/edit_off_sale_tab.dart';
import 'package:flutter/material.dart';

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
