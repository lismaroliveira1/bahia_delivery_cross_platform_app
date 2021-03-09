import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../data/data.dart';
import '../models/models.dart';
import '../tiles/tiles.dart';
import '../widgets/widgets.dart';

class CartTab extends StatefulWidget {
  final StoreData storeData;
  CartTab(this.storeData);
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 2.0,
              ),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "Carrinho",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            ScopedModelDescendant<UserModel>(builder: (context, cart, model) {
              List<CartProduct> cartByStore = model.cartProducts
                  .where((cartElement) =>
                      cartElement.storeId == widget.storeData.id)
                  .toList();
              if (model.isLoading) {
                return Container(
                  height: 0,
                  width: 0,
                );
              } else {
                return Column(
                  children: [
                    Column(
                      children: cartByStore.map((product) {
                        return CartTile(
                          cartProduct: product,
                          noProduct: _noProductInCart,
                        );
                      }).toList(),
                    ),
                    Column(
                      children: model.comboCartList
                          .map(
                            (combo) => ComboCartTile(combo),
                          )
                          .toList(),
                    )
                  ],
                );
              }
            }),
            DiscountCard(),
            ShipCard(),
            PaymentCard(),
            CartPrice(widget.storeData),
          ],
        ),
      ),
    );
  }

  void _noProductInCart() {}
}
