import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/cart_screen.dart';
import 'package:bahia_delivery/screens/product_screen.dart';
import 'package:bahia_delivery/screens/sale_off_store_screen.dart';
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
  bool hasProductData = false;
  bool isReadPurchasedProducts = false;

  @override
  Widget build(BuildContext context) {
    if (!isReadPurchasedProducts) {
      UserModel.of(context).getPurchasedProductsListByStore(
        widget.documentSnapshot.documentID,
      );
      UserModel.of(context).verifyOffSales(widget.documentSnapshot.documentID);
      UserModel.of(context).veryIfExistsProducts();
      isReadPurchasedProducts = true;
    }
    return Stack(
      children: [
        NestedScrollView(
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
                      widget.documentSnapshot.data["image"],
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
                      widget.documentSnapshot.data["title"],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  FutureBuilder<QuerySnapshot>(
                    future: Firestore.instance
                        .collection("stores")
                        .document(widget.documentSnapshot.documentID)
                        .collection("off")
                        .getDocuments(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      } else {
                        if (snapshot.data.documents.length > 0) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 0),
                                    child: Text(
                                      "Promoções",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 2, 8, 6),
                                child: Container(
                                  height: MediaQuery.of(context).size.width / 2,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children:
                                        snapshot.data.documents.map((doc) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 3,
                                        ),
                                        child: Container(
                                          child: FlatButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SalesOffStoreScreen(widget
                                                          .documentSnapshot),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 2.0,
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      child: FadeInImage
                                                          .memoryNetwork(
                                                        placeholder:
                                                            kTransparentImage,
                                                        image:
                                                            doc.data["image"],
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(doc.data["title"]),
                                                  Text(doc.data["description"]),
                                                  Text(doc.data["price"]
                                                      .toString()),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        }
                      }
                    },
                  ),
                  ScopedModelDescendant<UserModel>(
                      builder: (context, child, model) {
                    if (model.isLoading) {
                      return Container(
                        height: 0,
                        width: 0,
                      );
                    } else {
                      return model.purchasedProductsByStore.length > 0
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 20, 10, 0),
                                      child: Text(
                                        "Compre novamente",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 140,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: model.purchasedProductsByStore
                                        .map((doc) {
                                      double price = doc.data["price"];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 0,
                                        ),
                                        child: FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductScreen(
                                                  doc,
                                                  widget.documentSnapshot
                                                      .documentID,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                    image: new NetworkImage(
                                                        doc.data["image"]),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Text(
                                                  doc.data["title"],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Text(
                                                  price.toStringAsFixed(2),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              height: 0.0,
                              width: 0.0,
                            );
                    }
                  }),
                  ScopedModelDescendant<UserModel>(
                      builder: (context, child, model) {
                    if (model.isLoading) {
                      return Container(
                        height: 0,
                        width: 0,
                      );
                    } else {
                      if (model.hasSalesOff) {
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: Text(
                                "Seções",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      }
                    }
                  })
                ]),
              )
            ];
          },
          body: Container(
            child: FutureBuilder<QuerySnapshot>(
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
                    padding: EdgeInsets.zero,
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
                      height =
                          (MediaQuery.of(context).size.width * 0.95 * 0.5) *
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
                          child: Center(
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
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.hasProductInCart) {
                return FloatingActionButton(
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                  },
                );
              } else {
                return Container(
                  width: 0,
                  height: 0,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
