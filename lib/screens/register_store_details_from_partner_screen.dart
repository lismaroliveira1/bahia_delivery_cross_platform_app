import 'package:flutter/material.dart';

import '../data/data.dart';
import '../tabs/tabs.dart';

class RegisterStoreDetailsScreen extends StatelessWidget {
  final RequestPartnerData requestPartnerData;
  RegisterStoreDetailsScreen(this.requestPartnerData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegisterStoreDetailsTab(requestPartnerData),
    );
  }
}
