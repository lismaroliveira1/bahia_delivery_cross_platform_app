import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../components/components.dart';
import '../data/data.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import '../tabs/tabs.dart';

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
                children: model.cartDataList.map((cartData) {
                  double totalPrice = 0;
                  cartData.carts.forEach((product) {
                    totalPrice += product.price;
                  });
                  return Padding(
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
                            pageTransition(
                              context: context,
                              screen: CartTab(cartData.storeData),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Text("Custo do envio: R\$ 9,99"),
                                  Text(
                                      "Total: R\$ ${(totalPrice + 9.99).toStringAsFixed(2)}")
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    StoreData storeData;
                                    model.storeHomeList.forEach((store) {
                                      if (store.id == cartData.storeData.id) {
                                        storeData = store;
                                      }
                                    });
                                    pageTransition(
                                      context: context,
                                      screen: new WelcomeStoreScreen(
                                        storeData: storeData,
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
