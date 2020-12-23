import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderUserTab extends StatefulWidget {
  @override
  _OrderUserTabState createState() => _OrderUserTabState();
}

class _OrderUserTabState extends State<OrderUserTab> {
  List<ProductData> products = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScroled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
            )
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ScopedModelDescendant<UserModel>(
              builder: (context, chiil, model) {
            double _mediaSize = MediaQuery.of(context).size.width / 4;
            if (model.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: model.listUserOrders.map((order) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[400],
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: _mediaSize,
                              width: _mediaSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    order.storeImage,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: (MediaQuery.of(context).size.width -
                                      _mediaSize) *
                                  0.8,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pedido: ${order.id.substring(0, 6)}",
                                        ),
                                        Text(order.storeName)
                                      ],
                                    ),
                                    subtitle: _buildProductsAndComplements(
                                      order.products,
                                      order,
                                    ),
                                    trailing: StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection("orders")
                                          .doc(order.id)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          int status = snapshot.data['status'];
                                          if (status == 1) {
                                            return Column(
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Colors.lightBlue,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else if (status == 2) {
                                            return Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    'images/preparing_food.png',
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (status == 3) {
                                            return Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    'images/delivering.png',
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (status == 4) {
                                            return Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    'images/accept_icon.png',
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (status == 5) {
                                            return Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    'images/delete_icon.png',
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        } else {
                                          return Container(
                                            height: 0,
                                            width: 0,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("orders")
                                                .doc(order.id)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot.data["status"] ==
                                                    1) {
                                                  return Text(
                                                      "Aguardadndo Confirmação da loja");
                                                } else if (snapshot
                                                        .data["status"] ==
                                                    2) {
                                                  return Text(
                                                      "Pedido em preparação");
                                                } else if (snapshot
                                                        .data["status"] ==
                                                    3) {
                                                  return Text(
                                                    "Em transporte",
                                                  );
                                                } else if (snapshot
                                                        .data["status"] ==
                                                    4) {
                                                  return Text(
                                                    "Pedido Entregue",
                                                  );
                                                } else if (snapshot
                                                        .data["status"] ==
                                                    5) {
                                                  return Text(
                                                    "Pedido Cancelado",
                                                  );
                                                } else {
                                                  return Container();
                                                }
                                              } else {
                                                return Container(
                                                  height: 0,
                                                  width: 0,
                                                );
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildProductsAndComplements(
    List<ProductData> productsList,
    OrderData orderData,
  ) {
    products.clear();
    double shipPrice = orderData.shipPrice;
    for (ProductData product in productsList) {
      products.add(product);
    }
    double totalProductPrice = 0;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            orderData.paymentType,
          ),
          orderData.paymentType == 'Pagamento no app'
              ? orderData.paymentOnAppType == "DebitCard"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cartão de débito",
                        ),
                        Text(orderData.paymentInfo),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cartão de crédito",
                        ),
                        Text(orderData.paymentInfo),
                      ],
                    )
              : Text(
                  "",
                ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Itens: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("R\$ ${orderData.totalPrice.toStringAsFixed(2)}"),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                  "R\$ ${(orderData.totalPrice + orderData.shipPrice).toStringAsFixed(2)}"),
            ],
          ),
        ],
      ),
    );
  }
}
