import 'package:flutter/material.dart';

class CardFront extends StatelessWidget {
  final String cardNumber;
  final String cardOwnerName;
  final String cardValidateDate;
  final String cardCVV;
  final String asset;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CardFront(
      {@required this.cardNumber,
      @required this.cardOwnerName,
      @required this.cardValidateDate,
      @required this.cardCVV,
      @required this.asset});
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Card(
            elevation: 4,
            color: Color(0xFF090943),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: Container(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                        child: Image.asset(
                          "images/signal.png",
                          height: 25,
                          width: 25,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 12.0, top: 12.0, bottom: 40),
                        child: Image.asset(
                          'images/mastercard_logo.png',
                          height: 50,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/card_chip.png',
                          height: 50,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          cardNumber,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 18.0),
                    child: Text(
                      cardOwnerName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 4, 8, 14),
                    child: Text(
                      cardValidateDate,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
