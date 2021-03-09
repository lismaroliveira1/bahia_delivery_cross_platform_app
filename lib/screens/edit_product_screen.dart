import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

class EditProductScreen extends StatelessWidget {
  final ProductData productData;
  EditProductScreen(this.productData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EditProductTab(productData),
    );
  }
}
