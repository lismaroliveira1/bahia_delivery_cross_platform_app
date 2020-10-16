import 'dart:collection';

import 'package:bahia_delivery/data/order_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/chat_store_screnn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class OrderPartnerTile extends StatefulWidget {
  final OrderData orderData;
  OrderPartnerTile(this.orderData);

  @override
  _OrderPartnerTileState createState() => _OrderPartnerTileState();
}

class _OrderPartnerTileState extends State<OrderPartnerTile> {
  String firtstatus = "Aceitar Pedido";
  String secondStatus = "Enviar";
  String thirdStatus = "";
  @override
  Widget build(BuildContext context) {
    String month = '';
    switch (widget.orderData.createdAt.toDate().month) {
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
                  .document(widget.orderData.orderId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  int status = snapshot.data["status"];
                  switch (status) {
                    case 1:
                      firtstatus = "Aceitar \n Pedido";
                      secondStatus = "Enviar \n Pedido";
                      thirdStatus = "Pedido \n não entregue";
                      break;
                    case 2:
                      firtstatus = "Pedido \n Aceito";
                      secondStatus = "Enviar \n Pedido";
                      thirdStatus = "Pedido \n não entregue";
                      break;
                    case 3:
                      firtstatus = "Pedido \n aceito";
                      secondStatus = "Pedido \n enviado";
                      thirdStatus = "Pedido \n não entregue";
                      break;
                    case 4:
                      firtstatus = "Pedido \n Enviado";
                      secondStatus = "Enviar \n Pedido";
                      thirdStatus = "Pedido \n entregue";
                      break;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "Código do pedido: ${widget.orderData.orderId.substring(0, 6)}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              height: MediaQuery.of(context).size.height / 15,
                              width: MediaQuery.of(context).size.height / 15,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: snapshot.data["clientImage"]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0.0,
                              vertical: 4.0,
                            ),
                            child: Text(
                              snapshot.data["clientName"],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "Endereço",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 2.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data["clientAddress"]["street"]
                                  .toString(),
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 2.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Nº: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              snapshot.data["clientAddress"]["number"],
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              "Complemento: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              snapshot.data["clientAddress"]["complement"],
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 2.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Bairro: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              snapshot.data["clientAddress"]["district"],
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 2.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Cidade: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              snapshot.data["clientAddress"]["city"],
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              "Estado: ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              snapshot.data["clientAddress"]["state"],
                              overflow: TextOverflow.clip,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Itens",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Center(
                          child: Text(
                        _buildProductsText(widget.orderData.doc),
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(
                        height: 8.0,
                      ),
                      Center(
                        child: Text(
                          "Status",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              await Firestore.instance
                                  .collection("orders")
                                  .document(widget.orderData.orderId)
                                  .updateData({
                                "status": 2,
                              });
                              setState(() {
                                firtstatus = "Pedido aceito";
                              });
                            },
                            child: _buildCircle("1", firtstatus, status, 1),
                          ),
                          Spacer(),
                          FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              await Firestore.instance
                                  .collection("orders")
                                  .document(widget.orderData.orderId)
                                  .updateData({
                                "status": 3,
                              });
                              setState(() {
                                secondStatus = "Pedido enviado";
                              });
                            },
                            child: _buildCircle("2", secondStatus, status, 2),
                          ),
                          Spacer(),
                          FlatButton(
                              onPressed: () {},
                              child: _buildCircle("3", thirdStatus, status, 3))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "Data: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                widget.orderData.createdAt
                                        .toDate()
                                        .day
                                        .toString() +
                                    " de " +
                                    month +
                                    " de " +
                                    widget.orderData.createdAt
                                        .toDate()
                                        .year
                                        .toString() +
                                    " as " +
                                    widget.orderData.createdAt
                                        .toDate()
                                        .hour
                                        .toString() +
                                    ":" +
                                    widget.orderData.createdAt
                                        .toDate()
                                        .minute
                                        .toString()),
                          ],
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
                  onPressed: () {
                    UserModel.of(context).setChatData(widget.orderData);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(),
                      ),
                    );
                  }),
              Text(
                "Entre em contato com a loja",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
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
        style: TextStyle(color: Colors.white, fontSize: 11),
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
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 9),
        )
      ],
    );
  }
}
