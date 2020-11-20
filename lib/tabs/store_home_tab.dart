import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/create_edit_product_screen.dart';
import 'package:bahia_delivery/screens/order_store_screen.dart';
import 'package:bahia_delivery/screens/report_screen.dart';
import 'package:bahia_delivery/screens/sales_off_screen.dart';
import 'package:bahia_delivery/screens/setup_store_screnn.dart';
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
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Stack(
                      children: [
                        Container(
                          height: 100,
                        ),
                        !model.isStoreHourConfigurated
                            ? Positioned(
                                top: 14,
                                right: 14,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: FlatButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        _onAttentionButtonPressed();
                                      },
                                      child: Image.asset(
                                          'images/attention_icon.png')),
                                ))
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                      ],
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
                      onPressed: _onSalesOffStorePressed,
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
                      onPressed: _onSetupStoreScreenPressed,
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

  void _onSalesOffStorePressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SalesOffScreen(),
      ),
    );
  }

  void _onSetupStoreScreenPressed() {
    final storeData = UserModel.of(context).storeData;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SetupStoreScreen(storeData),
      ),
    );
  }

  void _onAttentionButtonPressed() {
    double imageSide = MediaQuery.of(context).size.width / 8;
    Scaffold.of(context).showSnackBar(SnackBar(
      elevation: 12,
      duration: Duration(minutes: 1),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      content: Container(
        height: 600,
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: imageSide,
                      width: imageSide,
                      child: Image.asset(
                        'images/logo.png',
                        height: imageSide,
                        width: imageSide,
                      ),
                    ),
                  ),
                  !UserModel.of(context).isStoreHourConfigurated
                      ? ListTile(
                          leading: Icon(
                            Icons.ac_unit,
                            size: 20,
                            color: Colors.black,
                          ),
                          title: Text(
                            "Horário de funcionamento",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            "Configure o horário de funcionamento da loja para que possa ser vista pelos clientes",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            final storeData = UserModel.of(context).storeData;
                            Scaffold.of(context).hideCurrentSnackBar();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    SetupStoreScreen(storeData),
                              ),
                            );
                          },
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                ],
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                  icon: Icon(
                    Icons.close_outlined,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    Scaffold.of(context).hideCurrentSnackBar();
                  }),
            )
          ],
        ),
      ),
    ));
  }
}
