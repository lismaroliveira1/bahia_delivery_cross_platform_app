import 'package:bahia_delivery/data/address_data.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:flutter/material.dart';

class AddressTile extends StatelessWidget {
  final AddressData address;
  AddressTile(this.address);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).pop();

              UserModel.of(context).setUserAddress(address);
            },
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    address.name,
                    textAlign: TextAlign.start,
                  ),
                  Text(address.street +
                      ", nº " +
                      address.number +
                      ", " +
                      address.complement),
                  Text(address.district),
                  Text(address.city + " - " + address.state)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
