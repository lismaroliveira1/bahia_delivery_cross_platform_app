import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/models.dart';

class ReportStoreTab extends StatefulWidget {
  @override
  _ReportStoreTabState createState() => _ReportStoreTabState();
}

class _ReportStoreTabState extends State<ReportStoreTab> {
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
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            double sallesByappPrice = 0;
            double sallesByDeliveryPrice = 0;
            double totalSallesPrice = 0;
            model.partnerOrderList.forEach((order) {
              totalSallesPrice += order.totalPrice;
              if (order.paymentType == "Pagamento no app") {
                sallesByappPrice += order.totalPrice;
              }
              if (order.paymentType == "Pagamento na Entrega") {
                sallesByDeliveryPrice += order.totalPrice;
              }
            });
            if (model.isLoading) {
              return Center(
                child: Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
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
                    _reportTile(
                      title: "Vendas com pagamentos pelo app",
                      quantity: model.partnerOrderList
                          .where((order) =>
                              order.paymentType == "Pagamento no app")
                          .length,
                      price: sallesByappPrice,
                    ),
                    _reportTile(
                      title: "Vendas com pagamentos na entrega",
                      quantity: model.partnerOrderList
                          .where((order) =>
                              order.paymentType == "Pagamento na Entrega")
                          .length,
                      price: sallesByDeliveryPrice,
                    ),
                    _reportTile(
                      title: "Total de vendas",
                      quantity: model.partnerOrderList.length,
                      price: totalSallesPrice,
                    ),
                    _reportTile(
                      title: "Seções",
                      quantity: model.sectionsStorePartnerList.length,
                    ),
                    _reportTile(
                      title: "Produtos",
                      quantity: model.productsPartnerList.length,
                    ),
                    _reportTile(
                      title: "Combos",
                      quantity: model.comboStoreList.length,
                    ),
                    _reportTile(
                      title: "Promoções",
                      quantity: model.offPartnerData.length,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _reportTile({
    @required String title,
    @required int quantity,
    double price,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      child: Card(
        elevation: 8,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                ),
                Spacer(),
                Text(
                  quantity.toString(),
                ),
                price != null ? Spacer() : Container(),
                price != null
                    ? Text("R\$ ${price.toStringAsFixed(2)}")
                    : Container(
                        height: 0,
                        width: 0,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
