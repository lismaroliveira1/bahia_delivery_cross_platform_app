import 'package:flutter/material.dart';

class DeliveryManForPartnerTab extends StatefulWidget {
  @override
  _DeliveryManForPartnerTabState createState() =>
      _DeliveryManForPartnerTabState();
}

class _DeliveryManForPartnerTabState extends State<DeliveryManForPartnerTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: Colors.black54,
              ),
            )
          ];
        },
        body: Container(),
      ),
    );
  }
}
