import 'package:bd_app_full/data/request_partner_data.dart';
import 'package:bd_app_full/tabs/register_store_details_tab.dart';
import 'package:flutter/material.dart';

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
