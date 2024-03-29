import 'package:animated_button/animated_button.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../data/data.dart';
import '../models/models.dart';

class OrderPartnerTile extends StatefulWidget {
  final OrderData orderData;
  final Function(String) setDeliveryMan;
  OrderPartnerTile(this.orderData, this.setDeliveryMan);

  @override
  _OrderPartnerTileState createState() => _OrderPartnerTileState();
}

class _OrderPartnerTileState extends State<OrderPartnerTile> {
  int statusGeneral;
  String firtstatus = "Aceitar Pedido";
  String secondStatus = "Enviar";
  String thirdStatus = "";
  String noImage = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  List<ProductData> products = [];
  @override
  void initState() {
    statusGeneral = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _imageSize = MediaQuery.of(context).size.width / 3;
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
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  if (snapshot.data["deliveryMan"] != "none") {
                    statusGeneral = 3;
                  }
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
                                  image: snapshot.data["clientImage"] != null
                                      ? snapshot.data["clientImage"]
                                      : noImage,
                                ),
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
                            child: Icon(
                              Icons.location_on,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 2.0,
                        ),
                        child: ListTile(
                          subtitle: Text(
                            widget.orderData.clientAddress,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
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
                      SizedBox(
                        height: 4.0,
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
                      status != 5
                          ? Center(
                              child: AnimatedButton(
                                color: status > 1 ? Colors.red : Colors.grey,
                                width: MediaQuery.of(context).size.width * 0.25,
                                height: 40,
                                onPressed: status > 1
                                    ? () {
                                        widget.setDeliveryMan(
                                            widget.orderData.id);
                                      }
                                    : null,
                                child: Text(
                                  'Entregador',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      status != 5
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              child: snapshot.data["deliveryMan"] != "none"
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: _imageSize,
                                              width: _imageSize,
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
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(snapshot
                                                  .data["deliveryMan"]["name"]),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    ),
                            )
                          : Container(
                              height: 0,
                              width: 0,
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
                      status == 5
                          ? Center(
                              child: Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'images/delete_icon.png'),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                TextButton(
                                  onPressed: status == 1
                                      ? () async {
                                          UserModel.of(context)
                                              .authorizePayByPartner(
                                            orderData: widget.orderData,
                                          );
                                          await FirebaseFirestore.instance
                                              .collection("orders")
                                              .doc(widget.orderData.id)
                                              .update({
                                            "status": 2,
                                          });

                                          setState(() {
                                            firtstatus = "Pedido aceito";
                                            status = 2;
                                          });
                                        }
                                      : null,
                                  child:
                                      _buildCircle("1", firtstatus, status, 1),
                                ),
                                TextButton(
                                  onPressed: status == 2
                                      ? () async {
                                          if (snapshot.data["deliveryMan"] ==
                                              "none") {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Defina quem é o entregador",
                                                  textAlign: TextAlign.center,
                                                ),
                                                backgroundColor: Colors.red,
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          } else {
                                            await FirebaseFirestore.instance
                                                .collection("orders")
                                                .doc(widget.orderData.id)
                                                .update({
                                              "status": 3,
                                            });
                                            setState(() {
                                              secondStatus = "Pedido enviado";
                                            });
                                          }
                                        }
                                      : () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Você deve aceitar o pedido antes",
                                                textAlign: TextAlign.center,
                                              ),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                  child: _buildCircle(
                                      "2", secondStatus, status, 2),
                                ),
                                TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Aguardando o reposta do entregador",
                                            textAlign: TextAlign.center,
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: _buildCircle(
                                        "3", thirdStatus, status, 3))
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: AnimatedButton(
                            color: Colors.red,
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: 40,
                            onPressed: status == 5
                                ? null
                                : () {
                                    if (status == 3) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.white,
                                          content: Container(
                                            color: Colors.white,
                                            height: 100,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "O Pedido já esta a caminho...\nTem certeza que deseja cancelar?",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black45,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 12,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .hideCurrentSnackBar();
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          width: 90,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: Colors.red,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "Não",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .hideCurrentSnackBar();
                                                          UserModel.of(context)
                                                              .cancelPayByPartner(
                                                            orderData: widget
                                                                .orderData,
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 35,
                                                          width: 90,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: Colors.red,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "Sim",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } else {
                                      UserModel.of(context).cancelPayByPartner(
                                        orderData: widget.orderData,
                                      );
                                    }
                                  },
                            child: Text(
                              status == 5
                                  ? "Pedido Cancelado"
                                  : 'Cancelar Pedido',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
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
                    /*UserModel.of(context).setChatData(widget.orderData);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(),
                      ),
                    );*/
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

  Widget _buildComboText(List<ComboData> comboList) {
    return Column(
      children: comboList
          .map(
            (combo) => Column(
              children: [
                ListTile(
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
    double shipPrice = widget.orderData.shipPrice;
    for (ProductData product in productsList) {
      products.add(product);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: products.map((product) {
        return ListTile(
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
                        Text("R\$ ${product.totalPrice}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Delivery: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("R\$ ${shipPrice.toStringAsFixed(2)}"),
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
                        Text("R\$ ${product.totalPrice}"),
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
    return Card(
      elevation: 4,
      child: Container(
        height: 60,
        width: 60,
        child: Center(
          child: Column(
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
          ),
        ),
      ),
    );
  }
}
