import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: Container(
          color: Colors.white,
          child: ExpansionTile(
            title: Text(
              "Cupom de Desconto",
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.grey[700]),
            ),
            leading: Icon(
              Icons.card_giftcard,
              color: Colors.grey,
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
                onPressed: () {}),
            children: <Widget>[
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Digite ser Cupon",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      )),
                  initialValue: UserModel.of(context).couponCode ?? "",
                  onFieldSubmitted: (text) {
                    FirebaseFirestore.instance
                        .collection("coupons")
                        .doc(text)
                        .get()
                        .then((docSnap) {
                      if (docSnap.data != null) {
                        UserModel.of(context).setCoupon(
                          text,
                          docSnap.get("percent"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Desconto de ${docSnap.get("percent")}% aplicado!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.transparent,
                        ));
                      } else {
                        UserModel.of(context).setCoupon(null, 0);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Cupon não encontrado!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        );
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
