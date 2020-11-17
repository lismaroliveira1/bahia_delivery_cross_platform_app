import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/insert_new_sale_off_screen.dart';
import 'package:bahia_delivery/widgets/store_home_widgets.dart';
import 'package:flutter/material.dart';

class SalesOffTab extends StatefulWidget {
  @override
  _SalesOffTabState createState() => _SalesOffTabState();
}

class _SalesOffTabState extends State<SalesOffTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            autocorrect: true,
            decoration: InputDecoration(
              labelText: "Pesquisar",
              hintText: "Sanduíche",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        StoreHomeWigget(
          icon: Icons.add_circle_outline_rounded,
          name: "Nova Promoção",
          description: "Crie novas promoções na sua loja",
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InsertNewSaleOffScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  void _onSuccess() {}
  void _onFail() {}
}
