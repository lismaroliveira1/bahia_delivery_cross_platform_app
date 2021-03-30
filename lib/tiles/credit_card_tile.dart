import 'package:flutter/material.dart';

import '../data/data.dart';
import '../models/models.dart';

class CreditDebitCardTileNB extends StatefulWidget {
  final CreditDebitCardData creditDebitCardData;
  CreditDebitCardTileNB(this.creditDebitCardData);

  @override
  _CreditDebitCardTileNBState createState() => _CreditDebitCardTileNBState();
}

class _CreditDebitCardTileNBState extends State<CreditDebitCardTileNB> {
  String _dropDownInitValue;
  List<String> _dropDownListItens = [];
  bool isTypePaymentOnAppChoosed;
  bool isDebit;
  @override
  void initState() {
    isDebit = widget.creditDebitCardData.isDebit;
    if (isDebit) {
      _dropDownListItens = [
        'Débito',
        'Crédito',
      ];
    } else {
      _dropDownListItens = [
        'Crédito',
        'Débito',
      ];
    }

    _dropDownInitValue = _dropDownListItens[0];
    isTypePaymentOnAppChoosed = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        /* Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentScreen(),
        ));*/
      },
      child: Row(
        children: <Widget>[
          Container(
            height: 20,
            child: Image.asset(
              widget.creditDebitCardData.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Text(
                  "*** *** *** " +
                      widget.creditDebitCardData.cardNumber.substring(15, 19),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: DropdownButton<String>(
                  value: _dropDownInitValue,
                  icon: Icon(
                    Icons.arrow_downward,
                  ),
                  elevation: 16,
                  iconSize: 16,
                  underline: Container(
                    height: 2,
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.red,
                  ),
                  onChanged: (String value) {
                    if (value == "Crédito") {
                      UserModel.of(context).currentCreditDebitCardData.isDebit =
                          false;
                    } else {
                      UserModel.of(context).currentCreditDebitCardData.isDebit =
                          true;
                    }
                    setState(() {
                      _dropDownInitValue = value;
                      isTypePaymentOnAppChoosed = true;
                    });
                  },
                  items: _dropDownListItens
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
