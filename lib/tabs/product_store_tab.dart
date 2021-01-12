import 'package:bd_app_full/data/cart_product.dart';
import 'package:bd_app_full/data/incremental_options_data.dart';
import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductStoreTab extends StatefulWidget {
  final ProductData productData;
  ProductStoreTab(this.productData);
  @override
  _ProductStoreTabState createState() => _ProductStoreTabState();
}

class _ProductStoreTabState extends State<ProductStoreTab> {
  List<IncrementalOptionalsData> incremetalsProduct;
  int quantity = 1;
  double complementPrice;
  @override
  void initState() {
    super.initState();
    incremetalsProduct = widget.productData.incrementalOptionalsList;
    complementPrice = 0;
  }

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
                  widget.productData.productImage,
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.productData.productTitle,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
          Expanded(
            child: GroupedListView<dynamic, String>(
              padding: EdgeInsets.symmetric(vertical: 5),
              elements: incremetalsProduct,
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
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
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
                                    int count = incremental.quantity - 1;
                                    setState(() {
                                      incremental.quantity = count;
                                    });
                                  }
                                : null,
                            icon: Icon(
                              Icons.remove,
                              color: incremental.quantity > 0
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          Text(
                            incremental.quantity.toString(),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              int count = incremental.quantity + 1;
                              setState(() {
                                incremental.quantity = count;
                              });
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
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 4.0,
                ),
                Text("$quantity"),
                Text(quantity > 1 ? "itens" : "item"),
                Text(" | "),
                Text(calcProductPrice()),
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
                        child: ScopedModelDescendant<UserModel>(
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
                    print(widget.productData.storeId);
                    CartProduct cartProduct = CartProduct();
                    cartProduct.category = widget.productData.category;
                    cartProduct.productImage = widget.productData.productImage;
                    cartProduct.pId = widget.productData.pId;
                    cartProduct.quantify = quantity;
                    cartProduct.storeId = widget.productData.storeId;
                    cartProduct.productDescription =
                        widget.productData.productDescription;
                    cartProduct.productTitle = widget.productData.productTitle;
                    cartProduct.productPrice = widget.productData.productPrice;
                    cartProduct.productOptionals = incremetalsProduct;
                    cartProduct.price = double.parse(calcProductPrice());
                    UserModel.of(context).addCartItem(
                      cartProduct: cartProduct,
                      onSuccess: _onSuccess,
                      onFail: _onFail,
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

  String calcProductPrice() {
    double complementFlagPrice = 0;
    for (IncrementalOptionalsData incrementalOptionalsData
        in incremetalsProduct) {
      complementFlagPrice = complementFlagPrice +
          incrementalOptionalsData.price * incrementalOptionalsData.quantity;
    }

    return ((complementFlagPrice + widget.productData.productPrice) * quantity)
        .toStringAsFixed(2);
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}
}
