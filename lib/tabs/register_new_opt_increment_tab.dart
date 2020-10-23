import 'dart:io';
import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/input_new_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterNewOptIncrementTab extends StatefulWidget {
  final ProductData productData;
  RegisterNewOptIncrementTab(this.productData);
  @override
  _RegisterNewOptIncrementTabState createState() =>
      _RegisterNewOptIncrementTabState();
}

class _RegisterNewOptIncrementTabState
    extends State<RegisterNewOptIncrementTab> {
  final bool isImageChoosed = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController maxQuantityController = TextEditingController();
  final TextEditingController minQuantityController = TextEditingController();
  final TextEditingController sessionController = TextEditingController();
  final String imageUrl =
      "https://www.meuvidraceiro.com.br/images/sem-imagem.png";

  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 120,
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width / 3,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: isImageChoosed
                            ? Image.file(
                                imageFile,
                                isAntiAlias: false,
                                height: MediaQuery.of(context).size.width / 3,
                                width: MediaQuery.of(context).size.width / 3,
                              )
                            : Image.network(
                                imageUrl,
                                isAntiAlias: false,
                                height: MediaQuery.of(context).size.width / 3,
                                width: MediaQuery.of(context).size.width / 3,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  InputNewProductWidget(
                    controller: titleController,
                    labelText: "Nome",
                    hintText: "",
                    maxLines: 1,
                  ),
                  InputNewProductWidget(
                    controller: descriptionController,
                    labelText: "Descrição",
                    hintText: null,
                    maxLines: 2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: InputNewProductWidget(
                          controller: priceController,
                          labelText: "Preço",
                          hintText: "1,99",
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: InputNewProductWidget(
                          controller: maxQuantityController,
                          labelText: "Quantidade \nMáxima",
                          hintText: "",
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: InputNewProductWidget(
                          controller: minQuantityController,
                          labelText: "Quantidade \nMínima",
                          hintText: "",
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  InputNewProductWidget(
                    controller: sessionController,
                    labelText: "Sessão",
                    hintText: null,
                    maxLines: 1,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: MediaQuery.of(context).size.width / 3,
                    child: ScopedModelDescendant<UserModel>(
                      builder: (context, child, model) {
                        if (model.isLoading) {
                          return Container(
                            height: 20,
                            width: 20,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          );
                        } else {
                          return FlatButton(
                            onPressed: () {},
                            child: Text(
                              "Inserir",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
