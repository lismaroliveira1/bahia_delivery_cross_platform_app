import 'package:bahia_delivery/data/store_data.dart';
import 'package:bahia_delivery/tabs/setup_store_tab.dart';
import 'package:flutter/material.dart';

class SetupStoreScreen extends StatelessWidget {
  final StoreData storeData;
  SetupStoreScreen(this.storeData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Configurações"),
      ),
      body: SetupStoreTab(storeData),
    );
  }
}
