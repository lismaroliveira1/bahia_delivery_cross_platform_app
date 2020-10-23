import 'package:bahia_delivery/widgets/store_home_widgets.dart';
import 'package:flutter/material.dart';

class OptionalTab extends StatefulWidget {
  @override
  _OptionalTabState createState() => _OptionalTabState();
}

class _OptionalTabState extends State<OptionalTab> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            StoreHomeWigget(
              icon: Icons.plumbing,
              name: "teste",
              description: "teste",
              onPressed: () {},
            )
          ]),
        ),
      ],
    );
  }
}
