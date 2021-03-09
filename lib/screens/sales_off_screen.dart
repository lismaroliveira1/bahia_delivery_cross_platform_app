import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

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
