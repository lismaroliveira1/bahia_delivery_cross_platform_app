import 'package:flutter/material.dart';

import '../tabs/tabs.dart';

class DeliveryManHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: DeliveryManHomeTab(),
      ),
    );
  }
}
