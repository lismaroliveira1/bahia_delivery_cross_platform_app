import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/edit_off_sales_screen.dart';
import 'package:bd_app_full/screens/new_off_partner_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';

class SalesOffPartnerTab extends StatefulWidget {
  @override
  _SalesOffPartnerTabState createState() => _SalesOffPartnerTabState();
}

class _SalesOffPartnerTabState extends State<SalesOffPartnerTab> {
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
                          child: NewSalesOffPartnerScreen(),
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
                    title: Text("Nova Promoção"),
                    subtitle: Text("Cadastre promoções na sua loja"),
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
                  if (model.offPartnerData.length > 0) {
                    return Container(
                      child: Expanded(
                        child: ListView(
                          children: model.offPartnerData
                              .map(
                                (offData) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.black54,
                                        )),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: EditOffSaleScreen(offData),
                                            type:
                                                PageTransitionType.rightToLeft,
                                            inheritTheme: true,
                                            duration: Duration(
                                              milliseconds: 350,
                                            ),
                                            ctx: context,
                                          ),
                                        );
                                      },
                                      leading: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              offData.image,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        offData.title,
                                      ),
                                      subtitle: Text(
                                        offData.description,
                                      ),
                                      trailing: Column(
                                        children: [],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 0,
                      width: 0,
                    );
                  }
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
