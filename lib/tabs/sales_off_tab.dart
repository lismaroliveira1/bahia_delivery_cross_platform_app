import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

import '../data/data.dart';
import '../models/models.dart';

class SalesOffTab extends StatefulWidget {
  final StoreData storeData;
  final OffData offData;
  SalesOffTab(
    this.storeData,
    this.offData,
  );
  @override
  _SalesOffTabState createState() => _SalesOffTabState();
}

class _SalesOffTabState extends State<SalesOffTab> {
  OffData offCartData;
  @override
  void initState() {
    super.initState();
    offCartData = OffData(
      description: widget.offData.description,
      image: widget.offData.image,
      title: widget.offData.title,
      productData: widget.offData.productData,
      imageFile: null,
      quantity: 1,
      price: widget.offData.productData.productPrice,
      storeId: widget.storeData.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
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
                                widget.offData.image,
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
                      widget.offData.title,
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
                          "-${widget.offData.discountPercentage.toStringAsFixed(0)}%",
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
                    child: Text(
                      offCartData.description,
                    ),
                  ),
                ),
              ],
            ),
          )
        ];
      },
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(
                              offCartData.productData.productImage,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 10, 0, 0),
                      child: Column(
                        children: [
                          Text(
                            offCartData.productData.productTitle,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            offCartData.productData.productTitle,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Text("de: "),
                              Text(
                                offCartData.productData.productPrice
                                    .toStringAsFixed(2),
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text("por: "),
                            Text(
                              "${(offCartData.productData.productPrice - widget.offData.productData.productPrice * widget.offData.discountPercentage / 100).toStringAsFixed(2)}",
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
                Text("${offCartData.quantity}"),
                Text(offCartData.quantity > 1 ? "itens" : "item"),
                Text(" | "),
                Text(
                  "${(offCartData.price * offCartData.quantity).toStringAsFixed(2)}",
                ),
                Container(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: offCartData.quantity > 1
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
                ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                    if (model.isLoading) {
                      return Center(
                        child: Container(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return FlatButton(
                        onPressed: () {
                          model.insertOffCart(
                            offData: offCartData,
                            onSuccess: onSuccess,
                            onFail: onFail,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3.5, horizontal: 9),
                                child: Text(
                                  "Adcionar ao \ncarrinho",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void decrementProduct() {
    setState(() {
      offCartData.quantity--;
    });
  }

  void incrementProduct() {
    setState(() {
      offCartData.quantity++;
    });
  }

  void onSuccess() {
    Navigator.of(context).pop();
  }

  void onFail() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Algo deu errado tente novamente",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
  }
}
