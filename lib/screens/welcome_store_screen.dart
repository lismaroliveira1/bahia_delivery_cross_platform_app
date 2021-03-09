import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

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
