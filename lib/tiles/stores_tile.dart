import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class ListStories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("stores").getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.center,
                height: 100,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            );
          } else {
            return SliverStaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              staggeredTiles: snapshot.data.documents.map((doc) {
                return StaggeredTile.count(2, 0.6);
              }).toList(),
              children: snapshot.data.documents.map((doc) {
                return Card(
                  child: Container(
                    padding: EdgeInsets.only(right: 12, left: 12),
                    height: 100,
                    child: Row(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: doc.data["image"],
                                fit: BoxFit.fill,
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 14, top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: <Widget>[
                                  Text(doc.data["title"],
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                doc.data["description"],
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            height: 50,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        });
  }
}
