import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/models.dart';

class DeliveryManForPartnerTab extends StatefulWidget {
  @override
  _DeliveryManForPartnerTabState createState() =>
      _DeliveryManForPartnerTabState();
}

class _DeliveryManForPartnerTabState extends State<DeliveryManForPartnerTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black26,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(
                  color: Colors.black54,
                ),
              )
            ];
          },
          body: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              double _imageSize = MediaQuery.of(context).size.width / 3;
              if (model.isLoading) {
                return Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Pesquisar',
                            labelText: 'Entregador',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Entregadores"),
                        ),
                        Expanded(
                          child: Expanded(
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
                                        color: Colors.white,
                                        elevation: 8,
                                        child: Container(
                                          color: Colors.white,
                                          height: _imageSize + 50,
                                          width: _imageSize + 50,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: _imageSize * 0.8,
                                                  width: _imageSize * 0.8,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          delivery.image),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          delivery.name,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        Text(
                                                          delivery.cpf,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
