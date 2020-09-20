import 'package:bahia_delivery/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupon de Desconto",
          style:
              TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: IconButton(icon: Icon(Icons.add), onPressed: () {}),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Digite ser Cupon"),
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (text) {
                Firestore.instance
                    .collection("coupons")
                    .document(text)
                    .get()
                    .then((docSnap) {
                  if (docSnap.data != null) {
                    CartModel.of(context)
                        .setCoupon(text, docSnap.data["percent"]);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Desconto de ${docSnap.data["percent"]}% aplicado!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.transparent,
                    ));
                  } else {
                    CartModel.of(context).setCoupon(null, 0);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Cupon não encontrado!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.transparent,
                    ));
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
