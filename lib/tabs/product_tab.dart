import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/data/incremental_optional_data.dart';
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
                _buildListOptOnlyChoose(),
                Expanded(
                  child: GroupedListView<dynamic, String>(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    elements: model.productOptionals,
                    groupBy: (incremental) => incremental.session,
                    useStickyGroupSeparators: false,
                    groupSeparatorBuilder: (String value) => Container(
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
                      Text("$quantity"),
                      Text(quantity > 1 ? "itens" : "item"),
                      Text(" | "),
                      Text(
                          "R\$ ${(snapshot.data["price"] + model.complementPrice) * quantity}"),
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
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3.5, horizontal: 9),
                                      child: Text(
                                        "Adcionar ao \ncarrinho",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
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
                          cartProduct.productImage = snapshot.data["image"];
                          cartProduct.pId = snapshot.documentID;
                          cartProduct.quantify = quantity;
                          cartProduct.storeId = storeId;
                          cartProduct.productDescription =
                              widget.snapshot.data["description"];
                          cartProduct.productTitle =
                              widget.snapshot.data["title"];
                          cartProduct.productPrice =
                              widget.snapshot.data["price"];
                          cartProduct.price =
                              (snapshot.data["price"] + model.complementPrice) *
                                  quantity;
                          cartProduct.productOptionals = model.productOptionals;
                          cartProduct.storeId = snapshot.data["storeID"];
                          CartModel.of(context).addCartItem(
                            cartProduct: cartProduct,
                            onSuccess: _onSuccess,
                            onFail: _onFail,
                            onDifferentStore: _onDifferentStore,
                          );
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

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onDifferentStore() {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.grey[100],
      duration: Duration(minutes: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      content: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Text(
                "Voce tem produtos no carrinho",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              ScopedModelDescendant<CartModel>(
                  builder: (context, child, model) {
                if (model.isLoading) {
                  return Container(
                    height: 0,
                    width: 0,
                  );
                } else {
                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: model.products.map((product) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 0,
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    product.productTitle,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "R\$ ${product.quantify} x ${product.productPrice}",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "R\$ " + product.price.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                  leading: Container(
                                    child: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(
                                          product.productImage,
                                          fit: BoxFit.cover,
                                          height: 60,
                                          width: 60,
                                          isAntiAlias: false,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                              onPressed: () {
                                model.clearCartProduct();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.red,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3.5, horizontal: 9),
                                  child: Text(
                                    "Limpar \ncarrinho",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                model.finishOrderWithPayOnDelivery();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.red,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3.5, horizontal: 9),
                                  child: Text(
                                    "Finalizar \ncompra",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              })
            ],
          ),
        ),
      ),
    ));
    print("Loja Diferente");
  }

  Widget _buildListOptOnlyChoose() {
    return Container(
      color: Colors.blue,
      height: 10,
    );
  }
}
