import 'dart:async';

import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/data/set_delivery_man_screen.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/chat_user_order_screen.dart';
import 'package:bd_app_full/screens/details_user_order_screnn.dart';
import 'package:bd_app_full/tabs/real_time_delivery_partner_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';

class RealTimeDeliveryPartnerScreen extends StatefulWidget {
  final OrderData orderData;
  RealTimeDeliveryPartnerScreen(this.orderData);

  @override
  _RealTimeDeliveryPartnerScreenState createState() =>
      _RealTimeDeliveryPartnerScreenState();
}

class _RealTimeDeliveryPartnerScreenState
    extends State<RealTimeDeliveryPartnerScreen>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;
  AnimatedIconData animatedIconData;
  OrderData orderData;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isSnackbarActive;
  bool isSearching;
  @override
  void initState() {
    isSearching = false;
    _isSnackbarActive = false;
    orderData = widget.orderData;
    initRealTime();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: RealTimeDeliveryPartnerTab(widget.orderData),
      floatingActionButton: !_isSnackbarActive
          ? FloatingActionBubble(
              backGroundColor: Colors.white,
              items: <Bubble>[
                Bubble(
                  title: "Detalhes",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.list_alt_rounded,
                  titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    _animationController.reverse();
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: DetailsUserOrderScreen(),
                        inheritTheme: true,
                        duration: Duration(
                          milliseconds: 350,
                        ),
                        ctx: context,
                      ),
                    );
                  },
                ),
                Bubble(
                  title: "Chat",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.message,
                  titleStyle: TextStyle(color: Colors.white),
                  onPress: () {
                    _animationController.reverse();
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: ChatUserOrderScreen(widget.orderData),
                        inheritTheme: true,
                        duration: Duration(
                          milliseconds: 350,
                        ),
                        ctx: context,
                      ),
                    );
                  },
                ),
                Bubble(
                  title: "Ligar",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.call,
                  titleStyle: TextStyle(color: Colors.white),
                  onPress: () {
                    _animationController.reverse();
                  },
                ),
                orderData.status <= 1
                    ? Bubble(
                        title: "Aceitar Pedido",
                        iconColor: Colors.white,
                        bubbleColor: Colors.blue,
                        icon: Icons.check,
                        titleStyle: TextStyle(color: Colors.white),
                        onPress: () async {
                          _animationController.reverse();
                          UserModel.of(context).authorizePayByPartner(
                            orderData: widget.orderData,
                          );
                          await FirebaseFirestore.instance
                              .collection("orders")
                              .doc(widget.orderData.id)
                              .update({
                            "status": 2,
                          });
                        },
                      )
                    : Bubble(
                        title: "Entregador",
                        iconColor: Colors.white,
                        bubbleColor: Colors.blue,
                        icon: Icons.delivery_dining,
                        titleStyle: TextStyle(color: Colors.white),
                        onPress: () async {
                          _animationController.reverse();
                          Timer(Duration(milliseconds: 500), () {
                            chooseDeliveryMan();
                          });
                        },
                      ),
                Bubble(
                  title: "Cancelar Pedido",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.cancel,
                  titleStyle: TextStyle(color: Colors.white),
                  onPress: () {
                    _animationController.reverse();
                  },
                ),
              ],
              animation: _animation,
              onPress: () => _animationController.isCompleted
                  ? _animationController.reverse()
                  : _animationController.forward(),

              // Floating Action button Icon color
              iconColor: Colors.blue,
              iconData: Icons.menu,
              // Flaoting Action button Icon
            )
          : null,
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
  }

  void chooseDeliveryMan() {
    setState(() {
      _isSnackbarActive = true;
    });
    _scaffoldKey.currentState
        .showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            duration: Duration(minutes: 1),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 18,
                    ),
                    child: TextField(
                      onChanged: (text) {
                        if (text.length > 1) {
                          setState(() {
                            isSearching = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Pesquisar",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  ScopedModelDescendant<UserModel>(
                    builder: (context, child, model) {
                      double _imageSize = MediaQuery.of(context).size.width / 3;
                      return Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          children: model.deliveryMans
                              .map(
                                (delivery) => FlatButton(
                                  onPressed: () {
                                    model.setDeliveryManToOrder(
                                      deliveryManData: delivery,
                                      orderId: orderData.id,
                                      onSuccess: _onSuccess,
                                      onFail: _onFail,
                                    );
                                  },
                                  padding: EdgeInsets.zero,
                                  child: Card(
                                    elevation: 8,
                                    child: Container(
                                      height: _imageSize + 50,
                                      width: _imageSize + 50,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: _imageSize * 0.8,
                                              width: _imageSize * 0.8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      delivery.image),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      delivery.name,
                                                    ),
                                                    Text(
                                                      delivery.cpf,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        )
        .closed
        .then((value) {
      setState(() {
        _isSnackbarActive = false;
      });
    });
  }

  void _onFail() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Algo saiu errado, tente novamente",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onSuccess() async {
    Timer(Duration(milliseconds: 2000), () {
      Navigator.of(context).pop();
    });
  }
}
