import 'package:bd_app_full/data/combo_data.dart';
import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/tabs/como_store_tab.dart';
import 'package:flutter/material.dart';

class ComboStoreScreen extends StatelessWidget {
  final ComboData comboData;
  final StoreData storeData;
  ComboStoreScreen(this.comboData, this.storeData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ComboStoreTab(
        comboData,
        storeData,
      ),
    );
  }
}
