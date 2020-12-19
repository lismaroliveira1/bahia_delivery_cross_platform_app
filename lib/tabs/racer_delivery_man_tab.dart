import 'package:flutter/material.dart';

class RacerDeliveryManTab extends StatefulWidget {
  @override
  _RacerDeliveryManTabState createState() => _RacerDeliveryManTabState();
}

class _RacerDeliveryManTabState extends State<RacerDeliveryManTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (
          BuildContext context,
          bool innerBoxIsScrolled,
        ) {
          return <Widget>[
            SliverAppBar(
              title: Text("Corridas"),
              backgroundColor: Colors.transparent,
              centerTitle: true,
            )
          ];
        },
        body: Container(),
      ),
    );
  }
}
