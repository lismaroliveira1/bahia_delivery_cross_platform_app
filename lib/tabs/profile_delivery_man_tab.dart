import 'package:flutter/material.dart';

class ProfileDeliveryManTab extends StatefulWidget {
  @override
  _ProfileDeliveryManTabState createState() => _ProfileDeliveryManTabState();
}

class _ProfileDeliveryManTabState extends State<ProfileDeliveryManTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text("Perfil"),
            ),
          ];
        },
        body: Container(),
      ),
    );
  }
}
