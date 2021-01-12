import 'package:bd_app_full/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CouponTab extends StatefulWidget {
  @override
  _CouponTabState createState() => _CouponTabState();
}

class _CouponTabState extends State<CouponTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScroled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
            )
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: model.couponUserData
                      .map(
                        (coupon) => Card(
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(4 - .0),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          coupon.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          coupon.description,
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                        "-${coupon.discount.toStringAsFixed(0)}%"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
