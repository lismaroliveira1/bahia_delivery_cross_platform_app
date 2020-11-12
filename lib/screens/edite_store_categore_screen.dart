import 'package:bahia_delivery/data/store_categore_data.dart';
import 'package:flutter/material.dart';

class EditStoreCategoreScreen extends StatelessWidget {
  final StoreCategoreData storeCategoreData;
  EditStoreCategoreScreen(this.storeCategoreData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edite"),
      ),
    );
  }
}
