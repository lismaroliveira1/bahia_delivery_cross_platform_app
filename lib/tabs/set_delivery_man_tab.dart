import 'package:bd_app_full/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SetDeliveryManTab extends StatefulWidget {
  @override
  _SetDeliveryManTabState createState() => _SetDeliveryManTabState();
}

class _SetDeliveryManTabState extends State<SetDeliveryManTab> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.height * 0.15;
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              collapsedHeight: MediaQuery.of(context).size.height * 0.15,
              flexibleSpace: Container(
                height: imageSize,
                width: imageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage('images/logo_and_name.jpg'),
                  ),
                ),
              ),
            )
          ];
        },
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 18,
              ),
              child: TextField(
                onChanged: (text) {
                  if (text.length > 1) {
                    setState(() {
                      isSearching = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: "Pesquisar",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
                double _imageSize = MediaQuery.of(context).size.width / 3;
                return Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: model.deliveryMans
                        .map(
                          (delivery) => FlatButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            child: Card(
                              elevation: 8,
                              child: Container(
                                height: _imageSize + 50,
                                width: _imageSize + 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: _imageSize,
                                        width: _imageSize,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(delivery.image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              delivery.name,
                                            ),
                                            Text(
                                              delivery.cpf,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
