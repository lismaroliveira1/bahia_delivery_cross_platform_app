import 'package:bahia_delivery/tabs/sales_off_store_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalesOffStoreScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;
  SalesOffStoreScreen(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SalesOffStoreTab(snapshot),
    );
  }
}
