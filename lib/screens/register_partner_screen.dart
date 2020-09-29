import 'package:bahia_delivery/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PartnerRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          height: 0,
          width: 0,
        ),
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[Container()],
            ),
          );
        },
      ),
    );
  }
}
