import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

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
