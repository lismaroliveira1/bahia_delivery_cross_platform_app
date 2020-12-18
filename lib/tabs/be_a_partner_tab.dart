import 'package:bd_app_full/screens/register_delivery_man_screen.dart';
import 'package:bd_app_full/screens/register_partner_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class BeAPartnerTab extends StatefulWidget {
  @override
  _BeAPartnerTabState createState() => _BeAPartnerTabState();
}

class _BeAPartnerTabState extends State<BeAPartnerTab> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height * 0.25;
    double _width = MediaQuery.of(context).size.width * 0.4;
    double _imageSize = MediaQuery.of(context).size.width / 3;
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrroled) {
          return <Widget>[];
        },
        body: Container(
          margin: EdgeInsets.only(
            top: 20,
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: _imageSize,
                  width: _imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(
                        'images/logo_and_name.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Text(
                  'Qual a sua modalidade',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: PartnerRegisterScreen(),
                            inheritTheme: true,
                            duration: Duration(
                              milliseconds: 350,
                            ),
                            ctx: context,
                          ),
                        );
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          height: _height,
                          width: _width,
                          child: Center(
                            child: Text(
                              "Parceiro",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: DeliveryManRegisterScreen(),
                            inheritTheme: true,
                            duration: Duration(
                              milliseconds: 350,
                            ),
                            ctx: context,
                          ),
                        );
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          height: _height,
                          width: _width,
                          child: Center(
                            child: Text(
                              "Entregador",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
