import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/edite_store_categore_screen.dart';
import 'package:bahia_delivery/screens/register_new_category_screnn.dart';
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
      StoreHomeWigget(
        icon: Icons.add_circle_outline_rounded,
        name: "Nova Categoria",
        description: "Cadastre novas categorias na sua loja",
        onPressed: _onNewCategoryPressed,
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Text("Categorias"),
          ],
        ),
      ),
      ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Expanded(
            child: ListView(
              children: model.storesCategoresList
                  .map((categoryData) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 2,
                              color: Colors.grey[300],
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditStoreCategoreScreen(categoryData),
                              ));
                            },
                            title: Text(
                              categoryData.title,
                            ),
                            subtitle: Text(
                              categoryData.description,
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                categoryData.image,
                                fit: BoxFit.cover,
                                height: 80,
                                width: 60,
                              ),
                            ),
                            trailing: Icon(Icons.edit),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          );
        }
      })
    ]);
  }

  void _onNewCategoryPressed() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RegisterNewCategoryScreen(),
    ));
  }
}
