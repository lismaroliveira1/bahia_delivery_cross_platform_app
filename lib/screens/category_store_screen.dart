import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/tabs/category_store_tab.dart';
import 'package:flutter/material.dart';

class CategoryStoreScreen extends StatelessWidget {
  final StoreData storeData;
  final String categoryId;
  CategoryStoreScreen(this.storeData, this.categoryId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CategoryStoreTab(storeData, categoryId),
    );
  }
}
