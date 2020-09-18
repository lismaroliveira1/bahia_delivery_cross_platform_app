import 'package:bahia_delivery/widgets/address_input_field.dart';
import 'package:bahia_delivery/widgets/cep_input_filed.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatefulWidget {
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Endereço de entrega",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
