import 'package:flutter/material.dart';

class SetupDeliveryManTab extends StatefulWidget {
  @override
  _SetupDeliveryManTabState createState() => _SetupDeliveryManTabState();
}

class _SetupDeliveryManTabState extends State<SetupDeliveryManTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrooled) {
          return <Widget>[
            SliverAppBar(
              title: Text("Configurações"),
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
          ];
        },
        body: Container(),
      ),
    );
  }
}
