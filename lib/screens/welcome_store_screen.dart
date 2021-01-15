import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/tabs/welcome_store_tab.dart';
import 'package:flutter/material.dart';

class WelcomeStoreScreen extends StatelessWidget {
  final StoreData storeData;
  WelcomeStoreScreen({
    @required this.storeData,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomeStoreTab(
        storeData: storeData,
      ),
    );
  }
}
