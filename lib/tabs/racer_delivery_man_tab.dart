import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/models.dart';
import '../screens/screens.dart';

class RacerDeliveryManTab extends StatefulWidget {
  @override
  _RacerDeliveryManTabState createState() => _RacerDeliveryManTabState();
}

class _RacerDeliveryManTabState extends State<RacerDeliveryManTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (
          BuildContext context,
          bool innerBoxIsScrolled,
        ) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              collapsedHeight: 200,
              flexibleSpace: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width / 3.5,
                    width: MediaQuery.of(context).size.width / 3.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/logo_and_name.jpg'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    child: Text(
                      "Corridas",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ];
        },
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView(
                children: model.deliveryManRacers
                    .map(
                      (deliveryManRacer) => Container(
                        height: 130,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.black54,
                              ),
                            ),
                            child: FlatButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: RealTimeDeliveryScreen(
                                      deliveryManRacer,
                                    ),
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
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          deliveryManRacer.storeImage,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Pedido: ${deliveryManRacer.id.substring(0, 6)}"),
                                        Text(
                                            "Cliente: ${deliveryManRacer.clientName}"),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              200,
                                          child: Text(
                                            "Endereço: ${deliveryManRacer.clientAddress}",
                                            overflow: TextOverflow.clip,
                                            softWrap: true,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
