import 'package:bahia_delivery/data/address_data.dart';
import 'package:flutter/material.dart';

class AddressTile extends StatelessWidget {
  final AddressData address;
  AddressTile(this.address);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        height: 70,
        child: Card(),
      ),
    );
  }
}
