import 'package:bahia_delivery/screens/register_new_product_screen.dart';
import 'package:bahia_delivery/widgets/store_home_widgets.dart';
import 'package:flutter/material.dart';

class CreateEditProductTab extends StatefulWidget {
  @override
  _CreateEditProductTabState createState() => _CreateEditProductTabState();
}

class _CreateEditProductTabState extends State<CreateEditProductTab> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              height: 100,
            ),
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
                name: "Novo Produto",
                description: "Cadastre novos produtos na sua loja",
                onPressed: _onNewProductWidgetPressed)
          ]),
        ),
      ],
    );
  }

  void _onNewProductWidgetPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterNewProductScreen(),
      ),
    );
  }
}
