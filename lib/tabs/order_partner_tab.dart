import 'package:bd_app_full/data/set_delivery_man_screen.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/tiles/order_partner_tile.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderPartnerTab extends StatefulWidget {
  @override
  _OrderPartnerTabState createState() => _OrderPartnerTabState();
}

class _OrderPartnerTabState extends State<OrderPartnerTab> {
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
            builder: (context, child, model) {
              if (model.isLoading) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Expanded(
                  child: ListView(
                      children: model.partnerOrderList
                          .map((order) => OrderPartnerTile(
                                order,
                                setDeliveryMan,
                              ))
                          .toList()),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void setDeliveryMan() {
    Navigator.push(
      context,
      new PageTransition(
        type: PageTransitionType.rightToLeft,
        child: new SetDeliveryManScreen(),
        inheritTheme: true,
        duration: new Duration(
          milliseconds: 350,
        ),
        ctx: context,
      ),
    );
  }
}
