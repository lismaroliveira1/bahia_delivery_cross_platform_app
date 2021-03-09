import 'package:bd_app_full/components/components.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../data/delivery_man_data.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class DeliveryManHomeTab extends StatefulWidget {
  @override
  _DeliveryManHomeTabState createState() => _DeliveryManHomeTabState();
}

class _DeliveryManHomeTabState extends State<DeliveryManHomeTab> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          DeliveryManData userDeliveryMan = model.userData.userDeliveryMan;
          return SafeArea(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    excludeHeaderSemantics: true,
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    expandedHeight: 250,
                    title: Text(
                      model.userData.userDeliveryMan.name,
                    ),
                    flexibleSpace: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.width / 3,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              userDeliveryMan.image,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                child: Column(
                  children: [
                    Text(userDeliveryMan.cpf),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () {
                            pageTransition(
                              context: context,
                              screen: new ChatDeliveryManScreen(),
                            );
                          },
                          leading: Icon(
                            Icons.list,
                          ),
                          title: Text("Chats"),
                          subtitle: Text("Acesse o histótico de seus chats"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () {
                            pageTransition(
                              context: context,
                              screen: new RacerDeliveryManScreen(),
                            );
                          },
                          leading: Icon(
                            Icons.list,
                          ),
                          title: Text("Corridas"),
                          subtitle: Text("Acesse o histótico de suas corridas"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () {
                            pageTransition(
                              context: context,
                              screen: ProfileDeliveryManScreen(),
                            );
                          },
                          leading: Icon(
                            Icons.list,
                          ),
                          title: Text("Perfil"),
                          subtitle: Text("Acesse o histótico de suas corridas"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () {
                            pageTransition(
                              context: context,
                              screen: new SetupDeliveryManScreen(),
                            );
                          },
                          leading: Icon(
                            Icons.list,
                          ),
                          title: Text("Configurações"),
                          subtitle: Text("Acesse o histótico de suas corridas"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
