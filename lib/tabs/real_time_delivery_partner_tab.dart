import 'package:bubble_timeline/bubble_timeline.dart';
import 'package:bubble_timeline/timeline_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../data/data.dart';

class RealTimeDeliveryPartnerTab extends StatefulWidget {
  final OrderData orderData;
  RealTimeDeliveryPartnerTab(this.orderData);
  @override
  _RealTimeDeliveryPartnerTabState createState() =>
      _RealTimeDeliveryPartnerTabState();
}

class _RealTimeDeliveryPartnerTabState
    extends State<RealTimeDeliveryPartnerTab> {
  List<TimelineItem> _items = [];
  DatabaseReference _deliveryManRealTimeLocation;
  double distance = 0;
  double duration = 0;
  double latEvent;
  double lngEvent;
  OrderData orderData;
  @override
  void initState() {
    orderData = widget.orderData;
    initRealTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _items = [
      TimelineItem(
        title: 'Pedido Realizado',
        description: 'Endereço: ${widget.orderData.clientAddress}',
        subtitle:
            'Horário: ${orderData.createdAt.toDate().hour}:${orderData.createdAt.toDate().minute}',
        child: Center(
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  orderData.clientImage,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        bubbleColor: Colors.grey,
      ),
      TimelineItem(
        title: orderData.status == 1
            ? "Aguardando a loja aceitar"
            : "Pedido aceito",
        subtitle: 'Travel through Oceans',
        child: orderData.status <= 1
            ? Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
            : Icon(
                Icons.check,
              ),
        bubbleColor: Colors.grey,
      ),
      orderData.isChoosedDeliveryMan && orderData.deliveryManAccepted
          ? TimelineItem(
              title: orderData.deliveryManData.name,
              subtitle: orderData.deliveryManData.cpf,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      orderData.deliveryManData.image,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              bubbleColor: Colors.grey,
            )
          : orderData.isChoosedDeliveryMan
              ? orderData.deliveryManAccepted
                  ? TimelineItem(
                      title: '${orderData.deliveryManData.name.split(" ")[0]}',
                      subtitle: 'Convite aceito',
                      child: Icon(
                        Icons.directions_bike,
                        color: Colors.white,
                      ),
                      bubbleColor: Colors.grey,
                    )
                  : TimelineItem(
                      title:
                          'Aguardando resposta de ${orderData.deliveryManData.name.split(" ")[0]}',
                      subtitle: 'Convite enviado',
                      child: Icon(
                        Icons.directions_bike,
                        color: Colors.white,
                      ),
                      bubbleColor: Colors.grey,
                    )
              : TimelineItem(
                  title: 'Entregador',
                  subtitle: 'Não definido',
                  child: Icon(
                    Icons.directions_bike,
                    color: Colors.white,
                  ),
                  bubbleColor: Colors.grey,
                ),
      TimelineItem(
        title: orderData.isFinished
            ? "${orderData.deliveryManData.name.split(" ")[0]} finalizou a entrega\nHorário: ${orderData.finishedAt.toString()}"
            : orderData.isSending
                ? "${orderData.deliveryManData.name.split(" ")[0]} inciou a entrega"
                : 'Entrega não iniciada',
        subtitle: orderData.isFinished
            ? ""
            : orderData.isSending
                ? "Duração: ${(duration / 60).toStringAsFixed(0)} min \n Distância ${(distance / 1000).toStringAsFixed(1)} Km"
                : orderData.isChoosedDeliveryMan
                    ? 'Aguardando ${orderData.deliveryManData.name.split(" ")[0]} iniciar a entrega'
                    : 'Entregador não definido',
        child: Icon(
          Icons.directions_bus,
          color: Colors.white,
        ),
        bubbleColor: Colors.grey,
      ),
    ];
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[];
        },
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      "Pedido: ${orderData.id.substring(0, 6)}",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width / 4,
                    width: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(
                          orderData.storeImage,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderData.storeName,
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.clip,
                          softWrap: true,
                        ),
                        Text(
                          orderData.storeDescription,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.clip,
                          softWrap: true,
                        ),
                        Text(
                          "Total: R\$${(orderData.totalPrice + orderData.shipPrice).toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.clip,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TextButton(
                      onPressed: () {
                        onProductListPressed();
                      },
                      child: Card(
                        elevation: 8,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage('images/product_list.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  child: BubbleTimeline(
                    bubbleDiameter: 120,
                    items: _items,
                    stripColor: Colors.teal,
                    scaffoldColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initRealTime() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(orderData.id)
        .snapshots()
        .listen((docSnapshot) {
      setState(() {
        orderData = OrderData.fromDocumentSnapshot(docSnapshot);
      });
    });
    _deliveryManRealTimeLocation = FirebaseDatabase.instance
        .reference()
        .child("orders")
        .child(orderData.id)
        .child("deliveryRealTimeLocation");

    _deliveryManRealTimeLocation.onValue.listen((event) {
      if (orderData.isSending) {
        update(
          dist: event.snapshot.value["distanceRemaining"],
          durat: event.snapshot.value["durationRemaining"],
          latEven: event.snapshot.value['lat'],
          lngEven: event.snapshot.value['lng'],
        );
      }
    });
  }

  void update({
    @required double dist,
    @required double durat,
    @required double latEven,
    @required double lngEven,
  }) {
    setState(() {
      distance = dist;
      duration = durat;
      latEvent = latEven;
      lngEvent = lngEven;
    });
  }

  void onProductListPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        duration: Duration(minutes: 1),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      "Produtos",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: orderData.products
                          .map(
                            (product) => Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    product.productTitle,
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${product.quantity.toStringAsFixed(0)} x ${product.productPrice}",
                                    style: TextStyle(
                                      color: Colors.black38,
                                    ),
                                  ),
                                  trailing: Text(
                                    "R\$${product.totalPrice.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: Colors.black38,
                                    ),
                                  ),
                                  leading: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          product.productImage,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Taxa de entrega: R\$ ${orderData.shipPrice.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Total: R\$ ${orderData.totalPrice.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 2,
                top: 2,
                child: IconButton(
                  icon: Icon(
                    Icons.close_fullscreen_rounded,
                    color: Colors.black54,
                    size: 15,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
