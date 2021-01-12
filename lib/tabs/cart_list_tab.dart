import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/tabs/cart_tab.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';

class CartListTab extends StatefulWidget {
  @override
  _CartListTabState createState() => _CartListTabState();
}

class _CartListTabState extends State<CartListTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: model.cartDataList
                    .map(
                      (cartData) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Card(
                          elevation: 8,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  new PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: new CartTab(cartData.storeData),
                                    inheritTheme: true,
                                    duration: new Duration(
                                      milliseconds: 350,
                                    ),
                                    ctx: context,
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            cartData.storeData.image,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartData.storeData.name,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text("Pizzas e Massas"),
                                      Text(
                                        cartData.carts.length > 1
                                            ? cartData.carts.length
                                                    .toStringAsFixed(0) +
                                                " itens"
                                            : cartData.carts.length
                                                    .toStringAsFixed(0) +
                                                " item",
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
