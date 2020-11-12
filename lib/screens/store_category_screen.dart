import 'package:bahia_delivery/tabs/store_categore_screen.dart';
import 'package:flutter/material.dart';

class CategoryStoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
        centerTitle: true,
      ),
      body: CategoryStoreTab(),
    );
  }
}
