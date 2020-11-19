import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalesOffStoreTab extends StatefulWidget {
  final DocumentSnapshot snapshot;
  SalesOffStoreTab(this.snapshot);
  @override
  _SalesOffStoreTabState createState() => _SalesOffStoreTabState();
}

class _SalesOffStoreTabState extends State<SalesOffStoreTab> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            expandedHeight: 200.0,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                child: Image.network(
                  widget.snapshot.data["image"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          new SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 2.0,
                ),
                child: Text(
                  widget.snapshot.data["title"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ]),
          ),
        ];
      },
      body: Container(
        height: 0,
      ),
    );
  }
}
