import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/store_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ListStories extends StatelessWidget {
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (model.isLoading) {
        return SliverToBoxAdapter(
          child: Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      } else {
        if (model.storeDataList.length == 0) {
          model.updateStories();
          return SliverToBoxAdapter(
            child: Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          return SliverToBoxAdapter(
            child: Container(
              child: Stack(
                children: [
                  Column(
                      children: model.storeDataList.map((doc) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 3.0,
                            right: 3.0,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite,
                                color: UserModel.of(context).isLoggedIn()
                                    ? Colors.red
                                    : Colors.grey,
                                size: 18,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      height: 75,
                                      width: 75,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: doc.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 4, 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc.name,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Container(
                                          child: Text(
                                            doc.description,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()),
                ],
              ),
            ),
          );
        }
      }
      return FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("stores").getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  height: 200,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              );
            else {
              return SliverStaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                staggeredTiles: snapshot.data.documents.map((doc) {
                  return StaggeredTile.count(2, 0.6);
                }).toList(),
                children: snapshot.data.documents.map((doc) {
                  bool contains = false;
                  return FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StoreScreen(doc),
                        ));
                      },
                      child: Card(
                        child: Stack(
                          children: [
                            Positioned(
                              top: 3.0,
                              right: 3.0,
                              child: IconButton(
                                onPressed: () {
                                  Firestore.instance
                                      .collection("users")
                                      .document(model.firebaseUser.uid)
                                      .collection("favorites")
                                      .getDocuments()
                                      .then((value) {
                                    for (DocumentSnapshot documentSnapshot
                                        in value.documents) {
                                      if (documentSnapshot.data["storeId"] ==
                                          doc.documentID) {
                                        if (documentSnapshot.data["status"]) {
                                          Firestore.instance
                                              .collection("users")
                                              .document(model.firebaseUser.uid)
                                              .collection("favorites")
                                              .document(doc.documentID)
                                              .setData({
                                            "storeId": doc.documentID,
                                            "status": false
                                          });
                                          contains = true;
                                          break;
                                        } else {
                                          Firestore.instance
                                              .collection("users")
                                              .document(model.firebaseUser.uid)
                                              .collection("favorites")
                                              .document(doc.documentID)
                                              .setData({
                                            "storeId": doc.documentID,
                                            "status": true
                                          });
                                          contains = true;
                                        }
                                      }
                                    }
                                    if (!contains) {
                                      Firestore.instance
                                          .collection("users")
                                          .document(model.firebaseUser.uid)
                                          .collection("favorites")
                                          .document(doc.documentID)
                                          .setData({
                                        "storeId": doc.documentID,
                                        "status": true
                                      });
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: UserModel.of(context).isLoggedIn()
                                      ? Colors.red
                                      : Colors.grey,
                                  size: 18,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 12, left: 12),
                              height: 100,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      height: 70,
                                      width: 70,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: doc.data["image"],
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(left: 14, top: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                }).toList(),
              );
            }
          });
    });
  }
}
