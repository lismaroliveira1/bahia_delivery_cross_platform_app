import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/store_home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CategoryStoreTab extends StatefulWidget {
  @override
  _CategoryStoreTabState createState() => _CategoryStoreTabState();
}

class _CategoryStoreTabState extends State<CategoryStoreTab> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(
          12.0,
        ),
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
      ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            children: [
              StoreHomeWigget(
                icon: Icons.add_circle_outline_rounded,
                name: "Nova Categoria",
                description: "Cadastre novas categorias na sua loja",
                onPressed: () {},
              ),
            ],
          );
        }
      })
    ]);
  }
}
