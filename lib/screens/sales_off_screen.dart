import 'package:bd_app_full/data/offs_data.dart';
import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/tabs/sales_off_tab.dart';
import 'package:flutter/material.dart';

class SalesOffScreen extends StatelessWidget {
  final StoreData storeData;
  final OffData offData;
  SalesOffScreen(
    this.storeData,
    this.offData,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SalesOffTab(
        storeData,
        offData,
      ),
    );
  }
}
