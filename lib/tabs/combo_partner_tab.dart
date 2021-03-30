import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class ComboPartnerTab extends StatefulWidget {
  @override
  _ComboPartnerTabState createState() => _ComboPartnerTabState();
}

class _ComboPartnerTabState extends State<ComboPartnerTab> {
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
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 6,
                ),
                child: Container(
                  margin: EdgeInsets.only(
                    top: 35,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black45,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      pageTransition(
                        context: context,
                        screen: new NewComboScrenn(),
                      );
                    },
                    dense: true,
                    leading: Icon(Icons.add_circle),
                    title: Text("Novo Combo"),
                    subtitle: Text("Cadastre novos combos na sua loja"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 8,
                ),
                child: TextField(
                  onChanged: (text) {},
                  decoration: InputDecoration(
                    labelText: "Pesquisar",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                if (model.isLoading) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView(
                      children: model.comboStoreList
                          .map(
                            (combo) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.black38,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    pageTransition(
                                      context: context,
                                      screen: new EditComboScreen(combo),
                                    );
                                  },
                                  title: Text(
                                    combo.title,
                                  ),
                                  subtitle: Text(combo.description),
                                  leading: Container(
                                    height: 65,
                                    width: 65,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          combo.image,
                                        ),
                                      ),
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
              })
            ],
          ),
        ),
      ),
    );
  }
}
