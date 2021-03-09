import 'package:bd_app_full/components/components.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../models/models.dart';
import '../screens/screens.dart';

class CategoryStorePartnerTab extends StatefulWidget {
  @override
  _CategoryStorePartnerTabState createState() =>
      _CategoryStorePartnerTabState();
}

class _CategoryStorePartnerTabState extends State<CategoryStorePartnerTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScroled) {
          return <Widget>[
            SliverAppBar(
              floating: false,
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
                padding: EdgeInsets.fromLTRB(8, 2, 8, 0),
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
                        screen: InsertNewSectionScreen(),
                      );
                    },
                    dense: true,
                    leading: Icon(Icons.add_circle),
                    title: Text("Nova Seção"),
                    subtitle: Text("Cadastre seções na sua loja"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
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
              Padding(
                padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: Row(
                  children: [
                    Text(
                      "Seções",
                    ),
                  ],
                ),
              ),
              ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                if (model.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: model.sectionsStorePartnerList.map((section) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 8,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.black38,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(4),
                              onTap: () {
                                pageTransition(
                                  context: context,
                                  screen: EditSectionScreen(section),
                                );
                              },
                              isThreeLine: true,
                              title: Text(
                                section.title,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                section.description,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              leading: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      section.image,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text("${section.order + 1}º"),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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
