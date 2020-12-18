import 'package:bd_app_full/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class DeliveryManHomeTab extends StatefulWidget {
  @override
  _DeliveryManHomeTabState createState() => _DeliveryManHomeTabState();
}

class _DeliveryManHomeTabState extends State<DeliveryManHomeTab> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SafeArea(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[];
              },
              body: Container(),
            ),
          );
        }
      },
    );
  }
}
