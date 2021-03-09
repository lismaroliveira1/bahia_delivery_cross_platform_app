import '../tabs/category_store_tab.dart';
import 'package:flutter/material.dart';

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
