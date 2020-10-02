import 'package:bahia_delivery/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class StoreHomeTab extends StatefulWidget {
  @override
  _StoreHomeTabState createState() => _StoreHomeTabState();
}

class _StoreHomeTabState extends State<StoreHomeTab> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (model.isLoading) {
        return Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              expandedHeight: MediaQuery.of(context).size.height / 6,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    color: Colors.black,
                  ),
                  child: Image.network(model.storeData.image),
                ),
              ),
            )
          ],
        );
      }
    });
  }
}
