import 'package:bd_app_full/screens/register_delivery_man.dart';
import 'package:bd_app_full/screens/register_partner_screen.dart';
import 'package:flutter/material.dart';

class BeAPartnerTab extends StatefulWidget {
  @override
  _BeAPartnerTabState createState() => _BeAPartnerTabState();
}

class _BeAPartnerTabState extends State<BeAPartnerTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => PartnerRegisterScreen(),
              ));
            },
            child: Card(
              child: Container(
                padding: EdgeInsets.all(12),
                height: 50,
                child: Text(
                  "Lojista",
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                ),
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DeliveryManRegisterScreen(),
              ));
            },
            child: Card(
              child: Container(
                padding: EdgeInsets.all(12),
                height: 50,
                child: Text(
                  "Entregador",
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
