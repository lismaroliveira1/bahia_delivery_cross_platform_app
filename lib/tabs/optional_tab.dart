import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/screens/register_new_opt_increment_screen.dart';
import 'package:bahia_delivery/tabs/register_new_opt_increment_tab.dart';
import 'package:bahia_delivery/widgets/store_home_widgets.dart';
import 'package:flutter/material.dart';

class OptionalTab extends StatefulWidget {
  final ProductData productData;
  OptionalTab(this.productData);
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
            Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              child: StoreHomeWigget(
                icon: Icons.add_circle_outline_outlined,
                name: "Incrementais",
                description: "teste",
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          RegisterNewOptIncrementScreen(widget.productData),
                    ),
                  );
                },
              ),
            ),
            StoreHomeWigget(
              icon: Icons.add_circle_outline,
              name: "Única escolha",
              description: "Adcione opcionais únicos por tipo",
              onPressed: () {},
            ),
          ]),
        ),
      ],
    );
  }
}
