import 'package:flutter/material.dart';

class FoodItem extends StatelessWidget {
  final String imgPath;
  final String foodName;
  final String price;
  final String description;
  FoodItem(this.imgPath, this.foodName, this.price, this.description);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 8, 40, 12),
                  child: Row(
                    children: [
                      Hero(
                          tag: imgPath,
                          child: Container(
                            height: 80,
                            width: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imgPath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodName,
                            style: TextStyle(
                              fontFamily: 'MontSerrat',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            price,
                            style: TextStyle(
                              fontFamily: 'MontSerrat',
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            description,
                            style: TextStyle(
                              fontFamily: 'MontSerrat',
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.black,
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
