import 'package:bahia_delivery/models/adress.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class AddressInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      final TextEditingController nameController = TextEditingController();
      final TextEditingController zipCodeController =
          TextEditingController(text: model.zipCode);
      final TextEditingController streetController =
          TextEditingController(text: model.street);
      final TextEditingController numberController = TextEditingController();
      final TextEditingController complementController =
          TextEditingController();
      final TextEditingController districtController =
          TextEditingController(text: model.district);
      final TextEditingController cityController =
          TextEditingController(text: model.city);
      final TextEditingController stateController =
          TextEditingController(text: model.state);
      if (model.isLoading && model.isLoggedIn()) {
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
          child: Card(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 2.5,
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
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        isDense: true,
                        labelText: 'Nome',
                        hintText: 'Casa/Trabalho',
                      ),
                      onSaved: (newValue) {
                        print(newValue);
                      },
                    ),
                    TextFormField(
                      controller: zipCodeController,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        isDense: true,
                        labelText: 'CEP',
                        hintText: '12345-678',
                        counterText: '',
                      ),
                    ),
                    TextFormField(
                      controller: streetController,
                      decoration: const InputDecoration(
                        isDense: true,
                        labelText: 'Rua/Avenida',
                        hintText: 'Av. Brasil',
                      ),
                      validator: empityValidator,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: numberController,
                            decoration: const InputDecoration(
                              isDense: true,
                              labelText: 'Número',
                              hintText: '123',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            validator: empityValidator,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
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
                    TextFormField(
                      controller: districtController,
                      decoration: const InputDecoration(
                        isDense: true,
                        labelText: 'Bairro',
                        hintText: 'Pelourinho',
                      ),
                      validator: empityValidator,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: cityController,
                            enabled: false,
                            decoration: const InputDecoration(
                                isDense: true,
                                labelText: 'Cidade',
                                hintText: 'Campinas'),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: stateController,
                            autocorrect: false,
                            enabled: false,
                            textCapitalization: TextCapitalization.characters,
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
                    SizedBox(
                      height: 24,
                    ),
                    Expanded(
                      child: Center(
                        child: FlatButton(
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LocationScreen()));
                            },
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
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  String empityValidator(String value) =>
      value.isEmpty ? 'Campo obrigatório' : null;
}
