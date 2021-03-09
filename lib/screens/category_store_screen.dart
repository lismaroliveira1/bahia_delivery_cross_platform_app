import 'package:flutter/material.dart';

import '../tabs/tabs.dart';
import '../data/data.dart';

class CategoryStoreScreen extends StatelessWidget {
  final StoreData storeData;
  final CategoryStoreData category;
  CategoryStoreScreen(this.storeData, this.category);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CategoryStoreTab(storeData, category),
    );
  }
}
