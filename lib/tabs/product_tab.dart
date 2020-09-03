import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductTab extends StatefulWidget {
  final DocumentSnapshot snapshot;
  ProductTab(this.snapshot);
  @override
  _ProductTabState createState() => _ProductTabState(snapshot);
}

class _ProductTabState extends State<ProductTab> {
  final DocumentSnapshot snapshot;
  _ProductTabState(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  snapshot.data["title"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                background: Image.network(
                  snapshot.data["image"],
                  fit: BoxFit.cover,
                ),
              ),
            )
          ];
        },
        body: Container());
  }
}
