import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class StoreHomeTab extends StatefulWidget {
  @override
  _StoreHomeTabState createState() => _StoreHomeTabState();
}

class _StoreHomeTabState extends State<StoreHomeTab> {
  String urlImage = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  bool flag;
  @override
  void initState() {
    super.initState();
  }

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
          } else if (model.listenChangeUser) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.userData.isPartner != 1) {
            return Center(
              child: Text(
                "Sua conta está\ntemporariamente suspensa",
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Container(
              color: Colors.black26,
              child: Stack(
                children: [
                  model.userData.image == null
                      ? Container(
                          height: 0,
                          width: 0,
                        )
                      : Positioned(
                          top: 0,
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: model.userData.storeImage != null
                                ? model.userData.storeImage
                                : urlImage,
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
                                    pageTransition(
                                      context: context,
                                      screen: new ReportStoreScreen(),
                                    );
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
                                    pageTransition(
                                      context: context,
                                      screen: new ProductStorePartnerScreen(),
                                    );
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
                                    pageTransition(
                                      context: context,
                                      screen: new CategoryStorePartnerScrenn(),
                                    );
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
                                    pageTransition(
                                      context: context,
                                      screen: new SalesOffPartnerScreen(),
                                    );
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
                                    pageTransition(
                                      context: context,
                                      screen: new StoreCouponsScreen(),
                                    );
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
                                    pageTransition(
                                      context: context,
                                      screen: new ComboPartnerScreen(),
                                    );
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
                                    pageTransition(
                                      context: context,
                                      screen: new OrderPartnerScreen(),
                                    );
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
                                    pageTransition(
                                      context: context,
                                      screen: new DeliveryManForPartnerScreen(),
                                    );
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
                                    pageTransition(
                                      context: context,
                                      screen: new SetupPartnerScreen(),
                                    );
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
}
