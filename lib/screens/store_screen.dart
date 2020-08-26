import 'package:bahia_delivery/tabs/store_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class StoreScreen extends StatefulWidget {
  final DocumentSnapshot snapshot;
  StoreScreen(this.snapshot);
  @override
  _StoreScreenState createState() => _StoreScreenState(snapshot);
}

class _StoreScreenState extends State<StoreScreen> {
  final DocumentSnapshot snapshot;

  _StoreScreenState(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreTab(snapshot),
    );
  }
}
