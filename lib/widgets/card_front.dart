import 'package:flutter/material.dart';

class CardFront extends StatelessWidget {
  final String cardNumber;
  final String cardOwnerName;
  final String cardValidateDate;
  final String cardCVV;
  final String cpf;
  final String asset;

  CardFront(
      {@required this.cardNumber,
      @required this.cardOwnerName,
      @required this.cardValidateDate,
      @required this.cardCVV,
      @required this.cpf,
      @required this.asset});
  @override
  Widget build(BuildContext context) {
    return Form(
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
              height: 260,
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
                          asset,
                          height: 50,
                          fit: BoxFit.cover,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NOME",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          cardOwnerName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 18.0),
                    child: Row(
                      children: [
                        Container(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CPF",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              Text(
                                cpf,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "VALIDADE",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Text(
                              cardValidateDate,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
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
