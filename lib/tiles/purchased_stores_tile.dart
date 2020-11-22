import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/welcome_store_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PurchasesStores extends StatefulWidget {
  @override
  _PurchasesStoresState createState() => _PurchasesStoresState();
}

class _PurchasesStoresState extends State<PurchasesStores> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.isLoading) {
          return Container(
            height: 0,
          );
        } else if (model.lastPurchasedStores.length > 0) {
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 2),
                    child: Text(
                      "Peça Novamente",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: model.lastPurchasedStores.map((doc) {
                    print(model.lastPurchasedStores.length);
                    return FlatButton(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              WelcomeStoreScreenn(doc.storeSnapshot),
                        ));
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.0,
                              vertical: 2.0,
                            ),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: new DecorationImage(
                                  image: new NetworkImage(
                                    doc.image,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            doc.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        } else {
          return Container(
            height: 0,
            width: 0,
          );
        }
      },
    );
  }
}
