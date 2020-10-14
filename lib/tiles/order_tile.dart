import 'dart:collection';

import 'package:bahia_delivery/data/order_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final OrderData orderData;
  OrderTile(this.orderData);
  @override
  Widget build(BuildContext context) {
    String month = '';
    switch (orderData.createdAt.toDate().month) {
      case 1:
        month = "Janeiro";
        break;
      case 2:
        month = "Fevereiro";
        break;
      case 3:
        month = "Março";
        break;
      case 4:
        month = "Abril";
        break;
      case 5:
        month = "Maio";
        break;
      case 6:
        month = "Junho";
        break;
      case 7:
        month = "julho";
        break;
      case 8:
        month = "Agosto";
        break;
      case 9:
        month = "Setembro";
        break;
      case 10:
        month = "Outubro";
        break;
      case 11:
        month = "Novembro";
        break;
      case 12:
        month = "Dezembro";
        break;
    }
    return Column(
      children: [
        Card(
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection("orders")
                  .document(orderData.orderId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  int status = snapshot.data["status"];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "Código do pedido: ${orderData.orderId.substring(0, 6)}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "Descrição",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(_buildProductsText(orderData.doc)),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildCircle("1", "Preparação", status, 1),
                          Container(
                            height: 1.0,
                            width: 40.0,
                            color: Colors.red,
                          ),
                          _buildCircle("1", "Transporte", status, 2),
                          Container(
                            height: 1.0,
                            width: 40.0,
                            color: Colors.red,
                          ),
                          _buildCircle("1", "Entrega", status, 3)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Data: " +
                              orderData.createdAt.toDate().day.toString() +
                              " de " +
                              month +
                              " de " +
                              orderData.createdAt.toDate().year.toString(),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
        Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  color: Colors.red[300],
                  padding: EdgeInsets.only(left: 12.0),
                  icon: Icon(Icons.message),
                  onPressed: () {}),
              Text(
                "Entre em contato com a loja",
                style: TextStyle(color: Colors.grey),
              ),
              IconButton(
                  color: Colors.red[300],
                  padding: EdgeInsets.only(right: 12.0),
                  icon: Icon(Icons.phone),
                  onPressed: () {})
            ],
          ),
        )
      ],
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = "";
    for (LinkedHashMap p in snapshot.data["products"]) {
      text +=
          "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${p["product"]["price"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.data["totalPrice"]}";
    return text;
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;
    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check);
    }
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 16.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
