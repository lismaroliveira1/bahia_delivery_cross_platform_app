import 'package:bahia_delivery/blocs/address_bloc.dart';
import 'package:bahia_delivery/models/adress.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/location_screen.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class AddressInputField extends StatefulWidget {
  @override
  _AddressInputFieldState createState() => _AddressInputFieldState();
}

class _AddressInputFieldState extends State<AddressInputField> {
  final _addressBloc = AddressBloc();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController complementController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

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
          return Center(
            child: Form(
              key: _formKey,
              child: Card(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              'Endereço de Entrega',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        ),
                        StreamBuilder<String>(
                            stream: _addressBloc.outName,
                            builder: (context, snapshot) {
                              return TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  isDense: true,
                                  labelText: 'Nome',
                                  hintText: 'Casa/Trabalho',
                                ),
                                onChanged: _addressBloc.changeOutName,
                              );
                            }),
                        StreamBuilder<String>(
                            stream: _addressBloc.outZipCode,
                            builder: (context, snapshot) {
                              return TextField(
                                controller: zipCodeController
                                  ..text = model.zipCode,
                                autocorrect: false,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'CEP',
                                  hintText: '12345-678',
                                  counterText: '',
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CepInputFormatter(),
                                ],
                                keyboardType: TextInputType.number,
                                onChanged: _addressBloc.changeOutZipCode,
                              );
                            }),
                        StreamBuilder<Object>(
                            stream: _addressBloc.outStreet,
                            builder: (context, snapshot) {
                              return TextField(
                                controller: streetController
                                  ..text = model.street,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'Rua/Avenida',
                                  hintText: 'Av. Brasil',
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                ),
                                onChanged:
                                    _addressBloc.changeOutStreetController,
                              );
                            }),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: StreamBuilder<String>(
                                  stream: _addressBloc.outNumber,
                                  builder: (context, snapshot) {
                                    return TextField(
                                      controller: numberController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelText: 'Número',
                                        hintText: '123',
                                        errorText: snapshot.hasError
                                            ? snapshot.error
                                            : null,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: _addressBloc
                                          .changeOutNumberController,
                                      keyboardType: TextInputType.number,
                                    );
                                  }),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: complementController,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  labelText: 'Complemento',
                                  hintText: 'Opicional',
                                ),
                              ),
                            ),
                          ],
                        ),
                        StreamBuilder<Object>(
                            stream: _addressBloc.outDistrict,
                            builder: (context, snapshot) {
                              return TextField(
                                controller: districtController
                                  ..text = model.district,
                                decoration: InputDecoration(
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  isDense: true,
                                  labelText: 'Bairro',
                                  hintText: 'Pelourinho',
                                ),
                                onChanged:
                                    _addressBloc.changeOutDistrictController,
                              );
                            }),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: cityController..text = model.city,
                                enabled: false,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  labelText: 'Cidade',
                                  hintText: 'Campinas',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: stateController..text = model.state,
                                autocorrect: false,
                                enabled: false,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  labelText: 'UF',
                                  hintText: 'BA',
                                  counterText: '',
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 12),
                        FlatButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            final address = Address(
                              name: nameController.text,
                              zipCode: zipCodeController.text,
                              street: streetController.text,
                              number: numberController.text,
                              complement: complementController.text,
                              district: districtController.text,
                              city: cityController.text,
                              state: stateController.text,
                              latitude: model.latitude,
                              longitude: model.longittude,
                            );
                            model.addAddress(address);
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 15,
                                width: MediaQuery.of(context).size.width / 2.3,
                                color: Colors.red,
                                child: Center(
                                  child: Text(
                                    "Cadastrar",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
