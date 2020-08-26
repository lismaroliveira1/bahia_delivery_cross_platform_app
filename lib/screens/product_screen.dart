import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final DocumentSnapshot snapshot;
  ProductScreen(this.snapshot);
  @override
  _ProductScreenState createState() => _ProductScreenState(snapshot);
}

class _ProductScreenState extends State<ProductScreen> {
  final DocumentSnapshot snapshot;
  _ProductScreenState(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text("ProductScreen"),
      ),
    );
  }
}
