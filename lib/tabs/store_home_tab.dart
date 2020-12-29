import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/category_store_partner_screen.dart';
import 'package:bd_app_full/screens/combo_partner_screen.dart';
import 'package:bd_app_full/screens/delivery_man_for_partner_screen.dart';
import 'package:bd_app_full/screens/off_sales_partner_screnn.dart';
import 'package:bd_app_full/screens/order_partner_screnn.dart';
import 'package:bd_app_full/screens/product_store_screnn.dart';
import 'package:bd_app_full/screens/report_store_screem.dart';
import 'package:bd_app_full/screens/setup_partner_screen.dart';
import 'package:bd_app_full/screens/store_coupons_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class StoreHomeTab extends StatefulWidget {
  @override
  _StoreHomeTabState createState() => _StoreHomeTabState();
}

class _StoreHomeTabState extends State<StoreHomeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              color: Colors.black26,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: model.userData.storeImage,
                      fit: BoxFit.cover,
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxScroled) {
                      return <Widget>[
                        SliverAppBar(
                          backgroundColor: Colors.transparent,
                          expandedHeight: 150,
                        )
                      ];
                    },
                    body: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black45,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    _onFanancialCashWidgetPressed();
                                  },
                                  dense: true,
                                  leading: Icon(
                                    Icons.article,
                                  ),
                                  title: Text("Relatórios"),
                                  subtitle: Text(
                                      "Visualize as movimentaçãoes realizadas na sua loja"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black45,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    _onProductWidgetPressed();
                                  },
                                  dense: true,
                                  leading: Icon(
                                    Icons.add_circle_outline,
                                  ),
                                  title: Text("Produtos"),
                                  subtitle: Text(
                                      "Adcione ou edite produtos na sua loja"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black45,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    _onSectionStoreWidgetPressed();
                                  },
                                  dense: true,
                                  leading: Icon(
                                    Icons.category,
                                  ),
                                  title: Text("Seções"),
                                  subtitle: Text(
                                    "Adcione ou edite seções e/ou subseções",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black45,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    _onSalesOffWidgetPressed();
                                  },
                                  dense: true,
                                  leading: Icon(Icons.bolt),
                                  title: Text(
                                    "Promoções",
                                  ),
                                  subtitle: Text(
                                    "Adicione ou edite promoções",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black45,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    _onCuponWidgetPressed();
                                  },
                                  dense: true,
                                  leading: Icon(Icons.bolt),
                                  title: Text(
                                    "Cupons",
                                  ),
                                  subtitle: Text(
                                    "Gerencie os cupons da sua loja",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black45,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    _onCombofWidgetPressed();
                                  },
                                  dense: true,
                                  leading: Icon(Icons.apps),
                                  title: Text(
                                    "Combos",
                                  ),
                                  subtitle: Text(
                                    "Adicione ou edite combos personalizadors",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black45,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    _onOrderWidgetPressed();
                                  },
                                  dense: true,
                                  leading: Icon(
                                    Icons.list_alt_rounded,
                                  ),
                                  title: Text(
                                    "Pedidos",
                                  ),
                                  subtitle: Text(
                                    "Consulte os andamentos e detalhes de seus pedidos",
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black45,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    _onDeliveryManWidgetPressed();
                                  },
                                  dense: true,
                                  leading: Icon(
                                    Icons.add_circle_outline,
                                  ),
                                  title: Text("Entregadores"),
                                  subtitle:
                                      Text("Adcione e gerencie entregadores"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black45,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    _onSetupStorePressed();
                                  },
                                  dense: true,
                                  leading: Icon(
                                    Icons.settings,
                                  ),
                                  title: Text(
                                    "Configurações",
                                  ),
                                  subtitle: Text(
                                    "Personalize sua loja",
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _onFanancialCashWidgetPressed() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: ReportStoreScreen(),
        inheritTheme: true,
        duration: Duration(
          milliseconds: 350,
        ),
        ctx: context,
      ),
    );
  }

  void _onProductWidgetPressed() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: ProductStorePartnerScreen(),
        inheritTheme: true,
        duration: Duration(
          milliseconds: 350,
        ),
        ctx: context,
      ),
    );
  }

  void _onSectionStoreWidgetPressed() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: CategoryStorePartnerScrenn(),
        inheritTheme: true,
        duration: Duration(
          milliseconds: 350,
        ),
        ctx: context,
      ),
    );
  }

  void _onSalesOffWidgetPressed() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: SalesOffPartnerScreen(),
        inheritTheme: true,
        duration: Duration(
          milliseconds: 350,
        ),
        ctx: context,
      ),
    );
  }

  void _onOrderWidgetPressed() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: OrderPartnerScreen(),
        inheritTheme: true,
        duration: Duration(
          milliseconds: 350,
        ),
        ctx: context,
      ),
    );
  }

  void _onSetupStorePressed() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: SetupPartnerScreen(),
        inheritTheme: true,
        duration: Duration(
          milliseconds: 350,
        ),
        ctx: context,
      ),
    );
  }

  void _onCombofWidgetPressed() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: ComboPartnerScreen(),
        inheritTheme: true,
        duration: Duration(
          milliseconds: 350,
        ),
        ctx: context,
      ),
    );
  }

  void _onCuponWidgetPressed() {
    Navigator.push(
      context,
      PageTransition(
        child: StoreCouponsScreen(),
        type: PageTransitionType.rightToLeft,
        inheritTheme: true,
        duration: Duration(
          milliseconds: 350,
        ),
        ctx: context,
      ),
    );
  }

  _onDeliveryManWidgetPressed() {
    Navigator.push(
      context,
      PageTransition(
        child: DeliveryManForPartnerScreen(),
        type: PageTransitionType.rightToLeft,
        inheritTheme: true,
        duration: Duration(
          milliseconds: 350,
        ),
        ctx: context,
      ),
    );
  }
}
