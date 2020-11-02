import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/tabs/register_new_opt_only_choose_tab.dart';
import 'package:flutter/material.dart';

class RegisterNewOptOnlyChooseScreen extends StatelessWidget {
  final ProductData productData;
  RegisterNewOptOnlyChooseScreen(this.productData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterNewOptOnlyChooseTab(productData),
    );
  }
}
