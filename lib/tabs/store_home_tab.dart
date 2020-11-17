import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/create_edit_product_screen.dart';
import 'package:bahia_delivery/screens/order_store_screen.dart';
import 'package:bahia_delivery/screens/report_screen.dart';
import 'package:bahia_delivery/screens/store_category_screen.dart';
import 'package:bahia_delivery/widgets/store_home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class StoreHomeTab extends StatefulWidget {
  @override
  _StoreHomeTabState createState() => _StoreHomeTabState();
}

class _StoreHomeTabState extends State<StoreHomeTab> {
  bool isVerifiedStore = false;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.isLoading) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(
                  model.storeName,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                expandedHeight: MediaQuery.of(context).size.height / 5.5,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      color: Colors.black,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: model.storeImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    StoreHomeWigget(
                      onPressed: _onFinancialCashWidgetPressed,
                      icon: Icons.article,
                      name: "Relatórios",
                      description:
                          "Visualize as movimentaçãoes realizadas na sua loja",
                    ),
                    StoreHomeWigget(
                      onPressed: _onProductWidgetPressed,
                      icon: Icons.add_circle_outline,
                      name: "Produtos",
                      description: "Adcione ou edite produtos na sua loja",
                    ),
                    StoreHomeWigget(
                      onPressed: _onCategoryStorePressed,
                      icon: Icons.category,
                      name: "Categorias",
                      description:
                          "Adcione ou edite categorias e organize os prodrutos",
                    ),
                    StoreHomeWigget(
                      onPressed: () {},
                      icon: Icons.bolt,
                      name: "Promoções",
                      description: "Adicione ou edite promoções",
                    ),
                    StoreHomeWigget(
                      onPressed: _onOrderStoredScreenPressed,
                      icon: Icons.list_alt_rounded,
                      name: "Pedidos",
                      description:
                          "Consulte os andamentos e detalhes de seus pedidos",
                    ),
                    StoreHomeWigget(
                      onPressed: () {},
                      icon: Icons.message_outlined,
                      name: "Chats",
                      description:
                          "Consulte o histórico de chats com os clientes",
                    ),
                    StoreHomeWigget(
                      onPressed: () {},
                      icon: Icons.settings,
                      name: "Configurações",
                      description: "Personalize sua loja",
                    )
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void _onFinancialCashWidgetPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReportScrenn(),
      ),
    );
  }

  void _onProductWidgetPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateEditProductScreen(),
      ),
    );
  }

  void _onCategoryStorePressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryStoreScreen(),
      ),
    );
  }

  void _onOrderStoredScreenPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderStoreScreen(),
      ),
    );
  }
}
