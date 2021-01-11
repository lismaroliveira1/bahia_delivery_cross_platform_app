import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/tabs/register_new_opt_incremental_tab.dart';
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
