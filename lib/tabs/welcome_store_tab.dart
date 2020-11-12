import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WelcomeStoreTab extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  WelcomeStoreTab(this.documentSnapshot);
  @override
  _WelcomeStoreTabState createState() => _WelcomeStoreTabState();
}

class _WelcomeStoreTabState extends State<WelcomeStoreTab> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
