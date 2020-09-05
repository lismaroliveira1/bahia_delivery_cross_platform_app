import 'package:bahia_delivery/data/cart_product.dart';
import 'package:bahia_delivery/models/cart_model.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FoodItem extends StatelessWidget {
  final String imgPath;
  final String foodName;
  final double price;
  final String description;
  final DocumentSnapshot snapshot;
  final String storeId;
  FoodItem(
      {@required this.storeId,
      @required this.imgPath,
      @required this.foodName,
      @required this.price,
      @required this.description,
      @required this.snapshot});
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
                            'R' + '\$' + price.toString(),
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
                    onPressed: () {
                      if (UserModel.of(context).isLoggedIn()) {
                        CartProduct cartProduct = CartProduct();
                        cartProduct.quantify = 1;
                        cartProduct.pId = snapshot.documentID;
                        cartProduct.category = snapshot.data["category"];
                        cartProduct.storeId = snapshot.data["storeID"];
                        CartModel.of(context).addCartItem(cartProduct);
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
