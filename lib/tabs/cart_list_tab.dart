import 'package:bd_app_full/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CartListTab extends StatefulWidget {
  @override
  _CartListTabState createState() => _CartListTabState();
}

class _CartListTabState extends State<CartListTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          print(model.carts.length);
          return SingleChildScrollView(
            child: Column(
              children: [],
            ),
          );
        },
      ),
    );
  }
}
