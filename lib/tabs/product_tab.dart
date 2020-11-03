import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/data/product_optional_data.dart';
import 'package:bahia_delivery/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductTab extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final String storeId;
  ProductTab(this.snapshot, this.storeId);
  @override
  _ProductTabState createState() => _ProductTabState(snapshot, storeId);
}

class _ProductTabState extends State<ProductTab> {
  final DocumentSnapshot snapshot;
  final String storeId;
  bool hasitem = false;
  List<OptionalProductData> optionals = [];
  _ProductTabState(this.snapshot, this.storeId);
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
          FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("stores")
                .document(storeId)
                .collection("products")
                .document(snapshot.documentID)
                .collection("incrementalOptions")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(height: 0);
              } else {
                int quantity = 0;
                return Expanded(
                  child: GroupedListView<dynamic, String>(
                    elements: snapshot.data.documents,
                    groupBy: (doc) => doc.data["session"],
                    useStickyGroupSeparators: false,
                    groupSeparatorBuilder: (String value) => Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              10.0,
                              5.0,
                              2.0,
                              6.0,
                            ),
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (c, doc) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Container(
                          child: ListTile(
                            dense: true,
                            title: Text(doc.data["title"]),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(doc.data["description"]),
                                Text(
                                  "R\$ ${doc.data["price"]}",
                                  style: TextStyle(
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    final optionalProductData =
                                        OptionalProductData.fromDocument(doc);

                                    decrementComplement(optionalProductData);
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                  ),
                                ),
                                Text(quantity.toString()),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                  ),
                                  onPressed: () {
                                    final optionalProductData =
                                        OptionalProductData.fromDocument(doc);

                                    int a = incrementComplement(
                                        optionalProductData);
                                    setState(() {
                                      quantity = 50;
                                    });
                                  },
                                )
                              ],
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  doc.data["image"],
                                  fit: BoxFit.fill,
                                  height: 40,
                                  width: 40,
                                  isAntiAlias: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 4.0,
                ),
                Text("1 Item"),
                Text(" | "),
                Text("R\$ ${snapshot.data["price"]}"),
                Container(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: ScopedModelDescendant<CartModel>(
                          builder: (context, child, model) {
                            if (model.isLoading) {
                              return CircularProgressIndicator();
                            } else {
                              return Text(
                                "Adcioonar ao \ncarrinho",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    CartProduct cartProduct = CartProduct();
                    cartProduct.category = snapshot.data["category"];
                    cartProduct.pId = snapshot.documentID;
                    cartProduct.productData =
                        ProductData.fromDocument(snapshot);
                    cartProduct.quantify = 1;
                    cartProduct.storeId = snapshot.data["storeID"];
                    CartModel.of(context)
                        .addCartItem(cartProduct: cartProduct, onFail: _onFail);
                  },
                )
              ],
            ),
          ),
          FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("stores")
                .document(storeId)
                .collection("products")
                .document(snapshot.documentID)
                .collection('"onlyChooseOptions"')
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  height: 0,
                );
              } else {
                return Expanded(
                  child: Column(
                    children: snapshot.data.documents.map((doc) {
                      return Container(
                        height: 0,
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _onFail() {
    print("erro");
  }

  int incrementComplement(OptionalProductData optionalProductData) {
    int quantity;
    setState(() {
      if (optionals.length == 0) {
        optionals.add(optionalProductData);
        quantity = 1;
      } else {
        for (var i = 0; i < optionals.length; i++) {
          if (optionals[i].id == optionalProductData.id) {
            if (optionals[i].quantity < optionalProductData.maxQuantity) {
              optionals[i].quantity++;
              quantity = optionals[i].quantity;
            } else {
              _onFailIncrementProduct();
              quantity = optionalProductData.maxQuantity;
            }
          } else {
            optionals.add(optionalProductData);
            quantity = 1;
          }
        }
      }
    });
    return quantity;
  }

  void decrementComplement(OptionalProductData optionalProductData) {
    for (var i = 0; i < optionals.length; i++) {
      if (optionals[i].id == optionalProductData.id) {
        setState(() {
          optionals.removeAt(i);
        });
        break;
      }
    }
    print(optionals.length);
  }

  void _onFailIncrementProduct() {
    print("maxQuantity");
  }
}
