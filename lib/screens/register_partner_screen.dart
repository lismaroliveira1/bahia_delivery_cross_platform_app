import 'package:bahia_delivery/widgets/input_register_form.dart';
import 'package:flutter/material.dart';

class PartnerRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              color: Colors.white,
            ),
            InputRegisterForm(title: "Nome\nFantasia", width: 280),
            InputRegisterForm(title: "CPF", width: 280),
            InputRegisterForm(
              title: "CNPJ",
              width: 280,
            )
          ],
        ),
      ),
    );
  }
}
