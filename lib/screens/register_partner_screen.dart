import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/location_screen.dart';
import 'package:bahia_delivery/widgets/input_register_form.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';

class PartnerRegisterScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
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
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "Imagem",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black),
                      ),
                    ],
                  ),
                  FlatButton(
                    onPressed: () async {
                      var status = await Permission.locationWhenInUse.status;

                      if (status.isDenied) {
                        //TODO Inplement GO to the settings function
                      } else if (status.isGranted) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LocationScreen(),
                        ));
                      } else if (status.isRestricted) {
                      } else if (status.isUndetermined) {
                        await Permission.locationWhenInUse.request();
                      } else if (status.isPermanentlyDenied) {
                        //Implementar para o mesmo abrir o settings
                      }
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Text(model.addressSeted
                            ? model.currentUserAddress.street +
                                ", nº " +
                                model.currentUserAddress.number
                            : "Localização"),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.location_on,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
