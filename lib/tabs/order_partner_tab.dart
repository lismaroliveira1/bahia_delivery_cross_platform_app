import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../tiles/tiles.dart';

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
              builder: (context, chiil, model) {
            if (model.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: model.partnerOrderList.map((order) {
                  return OrderTile(
                    orderData: order,
                    screen: RealTimeDeliveryPartnerScreen(order),
                  );
                }).toList(),
              );
            }
          }),
        ),
      ),
    );
  }
}
