import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/edit_product_screen.dart';
import 'package:bahia_delivery/screens/register_new_product_screen.dart';
import 'package:bahia_delivery/widgets/store_home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateEditProductTab extends StatefulWidget {
  @override
  _CreateEditProductTabState createState() => _CreateEditProductTabState();
}

class _CreateEditProductTabState extends State<CreateEditProductTab> {
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
          description: "Cadastre novos produtos na sua loja",
          onPressed: _onNewProductWidgetPressed,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text("Meus Produtos"),
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
                children: model.productsStore
                    .map(
                      (product) => Padding(
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
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                product.image,
                                fit: BoxFit.cover,
                                height: 80,
                                width: 60,
                              ),
                            ),
                            trailing: Icon(Icons.edit),
                            title: Text(product.title),
                            subtitle: Text(product.description),
                            onTap: () {
                              final productData = ProductData(
                                id: product.id,
                                title: product.title,
                                categoryId: product.categoryId,
                                description: product.description,
                                image: product.image,
                                price: product.price,
                                fullDescription: product.fullDescription,
                                group: product.group,
                              );

                              model.getIncrementalsFromProduct(productData.id);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProductScreen(productData),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          }
        })
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
