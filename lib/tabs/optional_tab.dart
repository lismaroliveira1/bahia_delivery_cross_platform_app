import 'package:bahia_delivery/data/product_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/register_new_opt_increment_screen.dart';
import 'package:bahia_delivery/screens/register_new_opt_only_choose_screen.dart';
import 'package:bahia_delivery/widgets/store_home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class OptionalTab extends StatefulWidget {
  final ProductData productData;
  OptionalTab(this.productData);
  @override
  _OptionalTabState createState() => _OptionalTabState();
}

class _OptionalTabState extends State<OptionalTab> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              child: StoreHomeWigget(
                icon: Icons.add_circle_outline_outlined,
                name: "Incrementais",
                description: "teste",
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          RegisterNewOptIncrementScreen(widget.productData),
                    ),
                  );
                },
              ),
            ),
            StoreHomeWigget(
              icon: Icons.add_circle_outline,
              name: "Única escolha",
              description: "Adcione opcionais únicos por tipo",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        RegisterNewOptOnlyChooseScreen(widget.productData),
                  ),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ScopedModelDescendant<UserModel>(
                    builder: (context, child, model) {
                  if (model.isLoading) {
                    return Container(
                      height: 0,
                    );
                  } else {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              Text(
                                model.productIncrementals.length > 0
                                    ? "Opcionais para ${widget.productData.title}"
                                    : "${widget.productData.title} não tem complementos",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Column(
                            children:
                                model.productIncrementals.map((incremental) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey[300],
                                ),
                              ),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    incremental.image,
                                    fit: BoxFit.cover,
                                    height: 80,
                                    width: 60,
                                  ),
                                ),
                                dense: true,
                                trailing: Icon(Icons.edit),
                                title: Text(incremental.title),
                                subtitle: Text(incremental.description),
                                onTap: () {
                                  print("ok");
                                },
                              ),
                            ),
                          );
                        }).toList()),
                      ],
                    );
                  }
                }),
              ),
            )
          ]),
        ),
      ],
    );
  }
}
