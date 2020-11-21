import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartTile extends StatefulWidget {
  final CartProduct cartProduct;
  CartTile(this.cartProduct);

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.width / 3.1,
      child: Column(
        children: [
          Center(
            child: Text(
              widget.cartProduct.productData.title,
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 17.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    widget.cartProduct.productData.image,
                    height: MediaQuery.of(context).size.width / 4.2,
                    width: MediaQuery.of(context).size.width / 4.2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.black54,
                                ),
                                onPressed: widget.cartProduct.quantify > 1
                                    ? () {
                                        CartModel.of(context)
                                            .decProduct(widget.cartProduct);
                                      }
                                    : null),
                            Text(
                              widget.cartProduct.quantify.toString(),
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                CartModel.of(context)
                                    .incProduct(widget.cartProduct);
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "R\$ ${widget.cartProduct.productData.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          padding: EdgeInsets.zero,
                          child: Text("Remover"),
                          textColor: Colors.grey[500],
                          onPressed: () {
                            CartModel.of(context)
                                .removeCartItem(widget.cartProduct);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
