import 'package:bahia_delivery/tabs/product_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final String storeId;
  ProductScreen(this.snapshot, this.storeId);

  @override
  _ProductScreenState createState() => _ProductScreenState(snapshot);
}

class _ProductScreenState extends State<ProductScreen> {
  final DocumentSnapshot snapshot;
  _ProductScreenState(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductTab(snapshot, widget.storeId),
    );
  }
}
