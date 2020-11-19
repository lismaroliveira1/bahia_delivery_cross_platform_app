import 'package:bahia_delivery/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SetupStoreTab extends StatefulWidget {
  @override
  _SetupStoreTabState createState() => _SetupStoreTabState();
}

class _SetupStoreTabState extends State<SetupStoreTab> {
  final TextEditingController _openHourController = TextEditingController();
  final TextEditingController _closeHourController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Horário",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Abre:"),
                Container(
                  width: 120,
                  child: TextField(
                    controller: _openHourController,
                  ),
                ),
                Text("Fecha:"),
                Container(
                  width: 120,
                  child: TextField(
                    controller: _closeHourController,
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            padding: EdgeInsets.zero,
            child: Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
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
                      height: 10,
                      width: 10,
                      child: Center(
                        heightFactor: 10,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Atualizar",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            onPressed: () {
              int openingHour =
                  int.parse(_openHourController.text.split(":")[0]);
              int openingMinute =
                  int.parse(_openHourController.text.split(":")[1]);
              int closingHour =
                  int.parse(_closeHourController.text.split(":")[0]);
              int closingMinute =
                  int.parse(_closeHourController.text.split(":")[1]);
              UserModel.of(context).updateStoreHours(
                openingTimeHour: openingHour,
                openingTimeMinute: openingMinute,
                closingTimeHour: closingHour,
                closingTimeMinute: closingMinute,
              );
            },
          ),
        ],
      ),
    );
  }
}
