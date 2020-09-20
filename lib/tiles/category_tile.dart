import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ListCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("categories").getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Colors.white,
            );
          } else
            return Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 120.0,
                width: 100.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data.documents.map((doc) {
                    return Container(
                      height: 120,
                      width: 120,
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12)),
                                height: 80,
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: doc.data["image"],
                                    fit: BoxFit.fill,
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Text(
                                doc.data["title"],
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ));
        });
  }
}
