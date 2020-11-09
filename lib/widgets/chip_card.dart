import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
        builder: (userContext, child, model) {
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ExpansionTile(
          title: model.addressSeted
              ? Text(
                  model.currentAddressDataFromGoogle.description.length < 40
                      ? model.currentAddressDataFromGoogle.description
                      : model.currentAddressDataFromGoogle.description
                              .substring(0, 40) +
                          "...",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey[700]),
                )
              : Text("Adcionar Endereço"),
          leading: Icon(Icons.location_on),
          trailing: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.add),
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LocationScreen(1)));
            },
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Digite se u CEP"),
                    initialValue: "",
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

class RegisterAdrressScreeen {}
