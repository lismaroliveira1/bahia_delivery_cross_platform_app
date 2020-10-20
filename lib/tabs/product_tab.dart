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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            expandedHeight: 200,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.network(
                  snapshot.data["image"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ];
      },
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text(
              snapshot.data["title"],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: Text(
              snapshot.data["fullDescription"],
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
