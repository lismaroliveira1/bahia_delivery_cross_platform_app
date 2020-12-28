import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/insert_new_coupon_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';

class StoreCouponsTab extends StatefulWidget {
  @override
  _StoreCouponsTabState createState() => _StoreCouponsTabState();
}

class _StoreCouponsTabState extends State<StoreCouponsTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              expandedHeight: 100.0,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  'images/logo_and_name.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ];
        },
        body: Container(
          margin: EdgeInsets.only(
            top: 20,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: InsertNewCouponScreen(),
                          type: PageTransitionType.rightToLeft,
                          inheritTheme: true,
                          duration: Duration(milliseconds: 350),
                          ctx: context,
                        ),
                      );
                    },
                    title: Text(
                      "Novo Cupom",
                    ),
                    leading: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            'images/coupon_item.png',
                          ),
                        ),
                      ),
                    ),
                    subtitle:
                        Text('Insira cupons comuns para todos os usuários'),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Cupons Válidos"),
                ),
                Expanded(child: ScopedModelDescendant<UserModel>(
                  builder: (context, child, model) {
                    return ListView(
                      children: model.couponsList
                          .map(
                            (coupon) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black26,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: InsertNewCouponScreen(),
                                        type: PageTransitionType.rightToLeft,
                                        inheritTheme: true,
                                        duration: Duration(milliseconds: 350),
                                        ctx: context,
                                      ),
                                    );
                                  },
                                  title: Text(
                                    coupon.title,
                                  ),
                                  leading: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                          'images/coupon_item.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                    coupon.message,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
