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
              centerTitle: true,
              title: Text(widget.snapshot.data["title"]),
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
        ];
      },
      body: Container(
        height: 0,
      ),
    );
  }
}
