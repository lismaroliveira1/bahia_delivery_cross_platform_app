import 'package:bahia_delivery/models/adress.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/address_input_field.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterAdrressScreeen extends StatefulWidget {
  @override
  _RegisterAdrressScreeenState createState() => _RegisterAdrressScreeenState();
}

class _RegisterAdrressScreeenState extends State<RegisterAdrressScreeen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.isLoading) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (!model.isLoggedIn()) {
          return Container(
            color: Colors.white,
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Entrega",
              ),
            ),
            body: AddressInputField(),
          );
        }
      },
    );
  }

  String empityValidator(String value) =>
      value.isEmpty ? 'Campo obrigatório' : null;
}
