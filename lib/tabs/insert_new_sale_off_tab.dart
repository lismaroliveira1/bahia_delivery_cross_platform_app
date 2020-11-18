import 'dart:io';

import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/data/sales_off_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/Input_product_parameters_widget.dart';
import 'package:bahia_delivery/widgets/store_home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class InsertNewSaleOffTab extends StatefulWidget {
  @override
  _InsertNewSaleOffTabState createState() => _InsertNewSaleOffTabState();
}

class _InsertNewSaleOffTabState extends State<InsertNewSaleOffTab> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  bool isImageChoosed = false;
  final String imageUrl = "https://meuvidraceiro.com.br/images/sem-imagem.png";
  File imageFile;
  final picker = ImagePicker();
  double totalPrice = 0;
  double subTotalPrice = 0;
  double discountPrice = 0;
  List<ProductData> products = [];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 40,
          ),
          child: Center(
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
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    bottom: 4.0,
                    right: 4.0,
                    child: IconButton(
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            content: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 12,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FlatButton(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width /
                                          18,
                                    ),
                                    onPressed: () async {
                                      try {
                                        final _pickedFile =
                                            await picker.getImage(
                                          source: ImageSource.gallery,
                                          maxHeight: 500,
                                          maxWidth: 500,
                                        );
                                        if (_pickedFile == null) return;
                                        imageFile = File(_pickedFile.path);
                                        if (imageFile == null) return;
                                        setState(() {
                                          isImageChoosed = true;
                                        });
                                      } catch (e) {
                                        setState(() {
                                          isImageChoosed = false;
                                        });
                                      }
                                    },
                                    child: Container(
                                      child: Image.asset(
                                        "images/gallery_image.png",
                                      ),
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  FlatButton(
                                    padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width /
                                          18,
                                    ),
                                    onPressed: () async {
                                      try {
                                        final _pickedFile =
                                            await picker.getImage(
                                          source: ImageSource.camera,
                                          maxHeight: 500,
                                          maxWidth: 500,
                                        );
                                        if (_pickedFile == null) return;
                                        imageFile = File(_pickedFile.path);
                                        if (imageFile == null) return;
                                        setState(() {
                                          isImageChoosed = true;
                                        });
                                      } catch (e) {
                                        setState(() {
                                          isImageChoosed = false;
                                        });
                                      }
                                    },
                                    child: Container(
                                      child: Image.asset(
                                        "images/camera_image.png",
                                      ),
                                      height: 50,
                                      width: 50,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: 4,
          ),
          child: EditProductParameters(
            controller: _titleController,
            initialText: "",
            hintText: "Leve 3 Pague 2",
            labelText: "Título da Promoção",
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: 4,
          ),
          child: EditProductParameters(
            controller: _descriptionController,
            initialText: "",
            hintText: "",
            labelText: "Descrição",
            minLines: 3,
            maxLines: 4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: EditProductParameters(
                  controller: _discountController,
                  initialText: "",
                  hintText: "",
                  labelText: "Desconto (%)",
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(),
              )
            ],
          ),
        ),
        StoreHomeWigget(
          icon: Icons.add_circle_outline_rounded,
          name: "Inserir produto",
          description: "Insira os produtos partipantes",
          onPressed: _onInsertProductPressed,
        ),
        products.length == 0
            ? Container(
                height: 0,
                width: 0,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 6,
                ),
                child: Column(
                  children: products.map((product) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Container(
                            height: 40,
                            width: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: product.image,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            product.title,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            product.description,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          onTap: () {},
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                            ),
                            onPressed: () {
                              List<ProductData> productsFlag = [];
                              productsFlag = products;
                              productsFlag.removeWhere(
                                (productData) => productData.id == product.id,
                              );
                              setState(() {
                                products = productsFlag;
                              });
                            },
                          ),
                        ),
                        Divider(
                          color: Colors.grey[600],
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Subtotal: R\$ ${subTotalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[600],
              ),
              Row(
                children: [
                  Text(
                    "Desconto: R\$ ${discountPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[600],
              ),
              Row(
                children: [
                  Text(
                    "Total: R\$ ${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red,
            ),
            child: ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
                if (model.isLoading) {
                  return Container(
                    child: Center(
                      child: Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                } else {
                  return FlatButton(
                    onPressed: () {
                      final saleOff = SalesOffData();
                      saleOff.title = _titleController.text;
                      saleOff.description = _descriptionController.text;
                      saleOff.products = products;
                      saleOff.discount = double.parse(
                        _discountController.text.replaceAll(",", "."),
                      );
                      saleOff.imageFile = imageFile;
                      model.insertNewOffSale(
                        onSuccess: _onSuccess,
                        onFail: _onFail,
                        salesOffData: saleOff,
                      );
                    },
                    child: Center(
                      child: Text(
                        "Inserir Promoção",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _onInsertProductPressed() {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      duration: Duration(
        seconds: 30,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      content: Container(
        height: 600,
        child:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: model.productsStore.map((product) {
                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        height: 40,
                        width: 40,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: product.image,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        product.title,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        product.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      onTap: () {
                        List<ProductData> productsFlag = [];
                        productsFlag = products;
                        productsFlag.add(product);
                        setState(() {
                          products = productsFlag;
                        });
                        calcules();
                        Scaffold.of(context).hideCurrentSnackBar();
                      },
                    ),
                    Divider(
                      color: Colors.grey[600],
                    )
                  ],
                );
              }).toList(),
            );
          }
        }),
      ),
    ));
  }

  void calcules() {
    double price = 0;

    double discount =
        double.tryParse(_discountController.text.replaceAll(",", "."));
    if (discount == null) {
      discount = 0;
    }
    for (ProductData productData in products) {
      price += productData.price;
    }
    setState(() {
      subTotalPrice = price;
      discountPrice = discount / 100;
      totalPrice = -(subTotalPrice * discountPrice) + subTotalPrice;
    });
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {}
}
