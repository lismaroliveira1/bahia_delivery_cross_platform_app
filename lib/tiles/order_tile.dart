import 'package:animated_button/animated_button.dart';
import 'package:bd_app_full/data/combo_data.dart';
import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/screens/real_time_delivery_screen.dart';
import 'package:bd_app_full/screens/real_time_delivery_user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:transparent_image/transparent_image.dart';

class OrderTile extends StatefulWidget {
  final OrderData orderData;
  OrderTile(this.orderData);

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  String firtstatus = "Aceitar Pedido";
  String secondStatus = "Enviar";
  String thirdStatus = "";
  List<ProductData> products = [];
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
              stream: FirebaseFirestore.instance
                  .collection("orders")
                  .doc(widget.orderData.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
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
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "Código do pedido: ${widget.orderData.id.substring(0, 6)}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
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
                              image: snapshot.data["storeImage"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          snapshot.data["StoreName"],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Center(
                        child: Text(
                          "Itens",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      widget.orderData.products.length > 0
                          ? _buildProductsAndComplements(
                              widget.orderData.products)
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      widget.orderData.combos.length > 0
                          ? _buildComboText(widget.orderData.combos)
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Entrega: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "R\$ " +
                                      widget.orderData.shipPrice
                                          .toStringAsFixed(2),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "R\$ " +
                                      widget.orderData.totalPrice
                                          .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: snapshot.data["deliveryMan"] != "none"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              snapshot.data["deliveryMan"]
                                                  ["image"],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(snapshot.data["deliveryMan"]
                                            ["name"]),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                      ),
                      Center(
                        child: AnimatedButton(
                          color: Colors.red,
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 40,
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: RealTimeDeliveryUserScreen(
                                    widget.orderData),
                                inheritTheme: true,
                                duration: new Duration(
                                  milliseconds: 350,
                                ),
                                ctx: context,
                              ),
                            );
                          },
                          child: Text(
                            'Acompanhar Pedido',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
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
                          _buildCircle("2", "Transporte", status, 2),
                          Container(
                            height: 1.0,
                            width: 40.0,
                            color: Colors.red,
                          ),
                          _buildCircle("3", "Entrega", status, 3)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                    /*UserModel.of(context).setChatData(widget.orderData);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatUserScreen(),
                      ),
                    );*/
                  }),
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

  Widget _buildComboText(List<ComboData> comboList) {
    return Column(
      children: comboList
          .map(
            (combo) => Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(
                    combo.quantity.toString() +
                        " x " +
                        combo.title +
                        " (R\$ ${combo.price.toStringAsFixed(2)})",
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "R\$ ${(combo.price * combo.quantity).toStringAsFixed(2)}",
                    ),
                  ],
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildProductsAndComplements(List<ProductData> productsList) {
    products.clear();
    for (ProductData product in productsList) {
      products.add(product);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: products.map((product) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(
            product.quantity.toString() +
                " x " +
                product.productTitle +
                " (R\$ ${product.productPrice})",
            textAlign: TextAlign.center,
          ),
          subtitle: product.complementProducts.length > 0
              ? Column(
                  children: [
                    Text(
                      "Complementos:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: product.complementProducts.map((complement) {
                        return Text(
                          complement.quantity.toString() +
                              " x " +
                              complement.title +
                              " (R\$ ${complement.price.toStringAsFixed(2)})",
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("R\$ ${product.totalPrice.toStringAsFixed(2)}"),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("R\$ ${product.totalPrice.toStringAsFixed(2)}"),
                      ],
                    ),
                  ],
                ),
        );
      }).toList(),
    );
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
