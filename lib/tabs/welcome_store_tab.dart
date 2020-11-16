import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/store_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class WelcomeStoreTab extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  WelcomeStoreTab(this.documentSnapshot);
  @override
  _WelcomeStoreTabState createState() => _WelcomeStoreTabState();
}

class _WelcomeStoreTabState extends State<WelcomeStoreTab> {
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
              title: Text(widget.documentSnapshot.data["title"]),
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                child: Image.network(
                  widget.documentSnapshot.data["image"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ];
      },
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("stores")
            .document(widget.documentSnapshot.documentID)
            .collection("categories")
            .orderBy(
              "order",
              descending: false,
            )
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return StaggeredGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 3.0,
              staggeredTiles: snapshot.data.documents.map((doc) {
                return StaggeredTile.count(
                  doc.data["x"],
                  doc.data["y"] + 0.3,
                );
              }).toList(),
              children: snapshot.data.documents.map((doc) {
                double width;
                double height;
                height = (MediaQuery.of(context).size.width * 0.95 * 0.5) *
                    doc.data["y"];
                width = (MediaQuery.of(context).size.width * 0.95 * 0.5) *
                    doc.data["x"];
                return Card(
                  elevation: 4,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StoreScreen(
                            snapshot: widget.documentSnapshot,
                            categoryId: doc.documentID,
                          ),
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 2.0,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              doc.data["image"],
                              fit: BoxFit.cover,
                              height: height,
                              width: width,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 2.0,
                          ),
                          child: Text(
                            doc.data["title"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 2.0,
                          ),
                          child: Text(
                            doc.data["description"],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
