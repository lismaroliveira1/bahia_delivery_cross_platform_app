import 'package:bahia_delivery/tabs/register_new_category_tab.dart';
import 'package:flutter/material.dart';

class RegisterNewCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Categoria"),
        centerTitle: true,
      ),
      body: RegisterNewCategoryTab(),
    );
  }
}
