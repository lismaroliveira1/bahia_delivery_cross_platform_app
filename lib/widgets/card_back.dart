import 'package:flutter/material.dart';

class CardBack extends StatelessWidget {
  final String cvv;
  CardBack(this.cvv);
  Widget build(BuildContext context) {
    return Form(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Card(
          color: Color(0xFF090943),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: 250,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  color: Colors.black,
                  height: 60,
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      height: 40,
                      width: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "CVV",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ),
                          Center(
                            child: Text(
                              cvv,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 70,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
