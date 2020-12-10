import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/create_new_product_screen.dart';
import 'package:bd_app_full/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductStorePartnerTab extends StatefulWidget {
  @override
  _ProductStorePartnerTabState createState() => _ProductStorePartnerTabState();
}

class _ProductStorePartnerTabState extends State<ProductStorePartnerTab> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScroled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
            )
          ];
        },
        body: Form(
          child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 6,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 35,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black45,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: CreateProductScreen(),
                                  inheritTheme: true,
                                  duration: Duration(
                                    milliseconds: 350,
                                  ),
                                  ctx: context,
                                ),
                              );
                            },
                            dense: true,
                            leading: Icon(Icons.add_circle),
                            title: Text("Novo Produto"),
                            subtitle:
                                Text("Cadastre novos produtos na sua loja"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Produtos",
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 8,
                        ),
                        child: TextField(
                          onChanged: (text) {
                            if (text.length > 1) {
                              setState(() {
                                isSearching = true;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Pesquisar",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.only(
                            top: 12.0,
                          ),
                          children: model.productsPartnerList.map((product) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 6.0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: EditProductScreen(product),
                                        inheritTheme: true,
                                        duration: Duration(
                                          milliseconds: 350,
                                        ),
                                        ctx: context,
                                      ),
                                    );
                                  },
                                  title: Text(
                                    product.productTitle,
                                  ),
                                  subtitle: Text(
                                    product.productDescription,
                                  ),
                                  leading: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(product.productImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  trailing: Text("R\$ ${product.productPrice}"),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
