import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/edit_section_screen.dart';
import 'package:bd_app_full/screens/new_section_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';

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
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: InsertNewSectionScreen(),
                          inheritTheme: true,
                          duration: Duration(
                            milliseconds: 350,
                          ),
                          ctx: context,
                        ),
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: EditSectionScreen(section),
                                    inheritTheme: true,
                                    duration: Duration(
                                      milliseconds: 350,
                                    ),
                                    ctx: context,
                                  ),
                                );
                              },
                              dense: true,
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
                                height: 60,
                                width: 60,
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
                              trailing: Text("${section.order + 1}º"),
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