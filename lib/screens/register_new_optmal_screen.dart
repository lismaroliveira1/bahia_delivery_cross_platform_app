import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

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
