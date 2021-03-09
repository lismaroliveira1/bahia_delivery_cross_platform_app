import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../data/data.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import '../tiles/tiles.dart';

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
            if (model.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: model.listUserOrders.map((order) {
                  return OrderTile(
                    orderData: order,
                    screen: RealTimeDeliveryUserScreen(
                      order,
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
}
