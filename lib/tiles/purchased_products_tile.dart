import 'package:flutter/material.dart';

import '../data/data.dart';

class PurchasedProduct extends StatefulWidget {
  final ProductData purchased;
  PurchasedProduct(this.purchased);
  @override
  _PurchasedProductState createState() => _PurchasedProductState();
}

class _PurchasedProductState extends State<PurchasedProduct> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              blurRadius: 1.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                2.0, // Move to right 10  horizontally
                2.0, // Move to bottom 10 Vertically
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300],
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.purchased.productImage,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(widget.purchased.productTitle),
              Text("R\$ ${widget.purchased.productPrice.toStringAsFixed(2)}")
            ],
          ),
        ),
      ),
    );
  }
}
