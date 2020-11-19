import 'package:bahia_delivery/tabs/setup_store_tab.dart';
import 'package:flutter/material.dart';

class SetupStoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Configurações"),
      ),
      body: SetupStoreTab(),
    );
  }
}
