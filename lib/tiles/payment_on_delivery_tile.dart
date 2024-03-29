import 'package:flutter/material.dart';

import '../data/data.dart';

class PaymentOnDeliveryTile extends StatelessWidget {
  final PaymentOnDeliveryData paymentOnDeliveryData;
  PaymentOnDeliveryTile(this.paymentOnDeliveryData);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        /*Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentScreen(),
        ));*/
      },
      child: Row(
        children: <Widget>[
          Container(
            height: 20,
            child: Image.asset(
              paymentOnDeliveryData.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            paymentOnDeliveryData.description
                    .replaceAll("(Visa ou Master)", "") +
                "  - (Pagemento na entrega)",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          )
        ],
      ),
    );
  }
}
