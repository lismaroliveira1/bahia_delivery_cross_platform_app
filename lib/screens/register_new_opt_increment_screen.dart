import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/tabs/register_new_opt_increment_tab.dart';
import 'package:flutter/material.dart';

class RegisterNewOptIncrementScreen extends StatelessWidget {
  final ProductData productData;
  RegisterNewOptIncrementScreen(this.productData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterNewOptIncrementTab(productData),
    );
  }
}
