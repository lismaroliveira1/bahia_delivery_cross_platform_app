import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/data/incremental_optional_data.dart';
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
  int quantity = 1;
  List<OptionalProductData> optionals = [];
  List<IncrementalOptData> productOptionals = [];
  bool isOptionalLoaded = false;

  _ProductTabState(this.snapshot, this.storeId);
  @override
  Widget build(BuildContext context) {
    if (!isOptionalLoaded) {
      CartModel.of(context).listOptionals(widget.snapshot, storeId);
      productOptionals = CartModel.of(context).productOptionals;
      isOptionalLoaded = true;
    }
    return ScopedModelDescendant<CartModel>(
      builder: (context, child, model) {
        if (model.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
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
                Expanded(
                  child: GroupedListView<dynamic, String>(
                    elements: model.productOptionals,
                    groupBy: (incremental) => incremental.session,
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
                    itemBuilder: (c, incremental) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Container(
                          child: ListTile(
                            dense: true,
                            title: Text(incremental.title),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(incremental.description),
                                Text(
                                  "R\$ ${incremental.price}",
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
                                  onPressed: incremental.quantity > 0
                                      ? () {
                                          model
                                              .decrementComplement(incremental);
                                        }
                                      : null,
                                  icon: Icon(
                                    Icons.remove,
                                    color: incremental.quantity > 0
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                                Text("${incremental.quantity}"),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    model.incrementComplement(
                                      incrementalOptData: incremental,
                                      onFail: _onFailIncrementProduct,
                                    );
                                  },
                                ),
                              ],
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  incremental.image,
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: 4.0,
                      ),
                      Text("$quantity Item"),
                      Text(" | "),
                      Text(
                          "R\$ ${snapshot.data["price"] * quantity + model.complementPrice}"),
                      Container(
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: quantity > 1
                                  ? () {
                                      decrementProduct();
                                    }
                                  : null,
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                incrementProduct();
                              },
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
                          cartProduct.quantify = quantity;
                          cartProduct.productOptionals = model.productOptionals;
                          cartProduct.storeId = snapshot.data["storeID"];
                          CartModel.of(context).addCartItem(
                              cartProduct: cartProduct, onFail: _onFail);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
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

  void incrementProduct() {
    setState(() {
      quantity++;
    });
  }

  void decrementProduct() {
    setState(() {
      quantity--;
    });
  }

  void computePriceComplement() {}
}
