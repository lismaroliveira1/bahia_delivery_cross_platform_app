import 'package:bd_app_full/data/combo_data.dart';
import 'package:bd_app_full/data/complement_data.dart';
import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class ComboStoreTab extends StatefulWidget {
  final ComboData comboData;
  final StoreData storeData;
  ComboStoreTab(
    this.comboData,
    this.storeData,
  );
  @override
  _ComboStoreTabState createState() => _ComboStoreTabState();
}

class _ComboStoreTabState extends State<ComboStoreTab> {
  ComboData comboCartData;
  @override
  void initState() {
    super.initState();
    comboCartData = ComboData(
      image: widget.comboData.image,
      title: widget.comboData.title,
      description: widget.comboData.description,
      discountPercentage: widget.comboData.discountPercentage,
      discountCoin: widget.comboData.discountCoin,
      products: widget.comboData.products,
      storeId: widget.storeData.id,
      id: widget.comboData.id,
      quantity: 1,
      price: 0,
    );
    comboCartData.price = computePrice();
  }

  double computePrice() {
    double priceProducts = 0;
    for (ProductData productData in widget.comboData.products) {
      double complemetPrice = 0;
      for (ComplementData complementData in productData.complementProducts) {
        complemetPrice = complementData.price++;
      }
      priceProducts = productData.productPrice + complemetPrice + priceProducts;
    }
    return priceProducts -
        priceProducts * widget.comboData.discountPercentage / 100;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    expandedHeight: 200.0,
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: widget.storeData.image,
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 14,
                          ),
                          child: Text(
                            widget.storeData.name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 135,
                                width: 135,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      widget.comboData.image,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                          child: Text(
                            widget.comboData.title,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.green[300],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "-${widget.comboData.discountPercentage.toStringAsFixed(0)}%",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                          child: Text(widget.comboData.description),
                        ),
                      ),
                    ]),
                  )
                ];
              },
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: widget.comboData.products
                            .map((product) => Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                product.productImage,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 10, 0, 0),
                                        child: Column(
                                          children: [
                                            Text(
                                              product.productTitle,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              product.productTitle,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              children: [
                                                Text("de: "),
                                                Text(
                                                  product.productPrice
                                                      .toStringAsFixed(2),
                                                  style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text("por: "),
                                              Text(
                                                "${(product.productPrice - product.productPrice * widget.comboData.discountPercentage / 100).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontSize: 22,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 4.0,
                        ),
                        Text("${comboCartData.quantity}"),
                        Text(comboCartData.quantity > 1 ? "itens" : "item"),
                        Text(" | "),
                        Text(
                          "${(comboCartData.price * comboCartData.quantity).toStringAsFixed(2)}",
                        ),
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: comboCartData.quantity > 1
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
                            UserModel.of(context).addCombotoCart(
                              comboData: comboCartData,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  void incrementProduct() {
    setState(() {
      comboCartData.quantity++;
    });
  }

  void decrementProduct() {
    setState(() {
      comboCartData.quantity--;
    });
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}
}
