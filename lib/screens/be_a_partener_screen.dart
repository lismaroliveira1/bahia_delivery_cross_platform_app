import 'package:bahia_delivery/screens/register_partner_screen.dart';
import 'package:bahia_delivery/screens/register_delivery_man.dart';
import 'package:flutter/material.dart';


class BeAParterScreen extends StatefulWidget {
  @override
  _BeAParterScreenState createState() => _BeAParterScreenState();
}

class _BeAParterScreenState extends State<BeAParterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          "Selecione a modalidade",
        )),
      ),
      body: ListView(
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
