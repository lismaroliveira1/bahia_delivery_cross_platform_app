import 'package:bahia_delivery/models/user_model.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class CepInputField extends StatefulWidget {
  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              labelText: 'CEP',
              hintText: '12.345-678',
            ),
            keyboardType: TextInputType.number,
            validator: (postalCode) {
              if (postalCode.isEmpty) {
                return 'Campo Obrigatório';
              } else if (postalCode.length != 10) {
                return 'CEP incorreto';
              } else
                return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter()
            ],
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
              child: Text("Buscar CEP"),
              textColor: Colors.red,
              onPressed: () {
                //TODO buscar o endereço pela API
              })
        ],
      );
    });
  }
}
