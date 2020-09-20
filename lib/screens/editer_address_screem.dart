import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/address_input_field.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterAdrressScreeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Entrega",
          ),
        ),
        body: AddressInputField(),
      );
    });
  }
}
