import 'package:bahia_delivery/tabs/welcome_store_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WelcomeStoreScreenn extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  WelcomeStoreScreenn(this.documentSnapshot);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomeStoreTab(documentSnapshot),
    );
  }
}
