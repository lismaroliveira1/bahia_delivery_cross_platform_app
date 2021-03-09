import 'dart:async';

import 'package:animated_button/animated_button.dart';

import 'package:flutter/material.dart';
import 'package:kt_drawer_menu/kt_drawer_menu.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import '../tiles/tiles.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool isAddressSeted;
  LocationData locationData;
  Location location = Location();
  void initState() {
    isAddressSeted = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      double addressWidgetWidth = MediaQuery.of(context).size.width * 0.15;
      if (model.isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Stack(
          children: [
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  floating: true,
                  snap: true,
                  expandedHeight: 60,
                  flexibleSpace: Container(
                    height: 60,
                    margin: EdgeInsets.only(top: 65),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Card(
                                elevation: 8,
                                child: new IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    KTDrawerMenu.of(context).toggle();
                                  },
                                  icon: Icon(
                                    Icons.sort,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Image.asset(
                            "images/logo.png",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            child: Container(
                              height: 35,
                              width: 35,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Card(
                                  elevation: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: FlatButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () => pageTransition(
                                        context: context,
                                        screen: new CartListScreen(),
                                      ),
                                      child: Image.asset(
                                        "images/cart_icon.png",
                                        width: 15,
                                        height: 15,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: addressWidgetWidth,
                      ),
                      child: FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          Timer(Duration(milliseconds: 500), () {
                            pageTransition(
                              context: context,
                              screen: new RegisterAddressScreen(),
                            );
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              height: 25,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: ScopedModelDescendant<UserModel>(
                                  builder: (context, child, model) {
                                    return Container(
                                      child: Text(
                                        model.addressSeted
                                            ? UserModel.of(context)
                                                    .addressToRegisterPartner
                                                    .substring(0, 40) +
                                                "..."
                                            : "Endereço de entrega",
                                        overflow: TextOverflow.clip,
                                        softWrap: true,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                      ),
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: model.categoryList.map((category) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image: NetworkImage(
                                        category.image,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                category.title,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    model.lastPurchasedStores.length > 0
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  bottom: 12,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Compre Novamente",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                height: 150,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: model.lastPurchasedStores
                                      .map((purchasedStore) {
                                    return FlatButton(
                                      onPressed: () {
                                        model.addressSeted
                                            ? pageTransition(
                                                context: context,
                                                screen: WelcomeStoreScreen(
                                                  storeData: purchasedStore,
                                                ),
                                              )
                                            : loadAddres();
                                      },
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                        child:
                                            PurchasedStoreTile(purchasedStore),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 12),
                      child: Text(
                        "Lojas",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Column(
                      children: model.storeHomeList.map((store) {
                        store.coupons.forEach((coupon) {
                          /*if (coupon.discount > store.discount &&
                              coupon.start.isBefore(DateTime.now())) {
                            store.discount = coupon.discount;
                          }*/
                        });
                        return StoreHomeTile(store);
                      }).toList(),
                    ),
                  ]),
                )
              ],
            ),
          ],
        );
      }
    });
  }

  void loadAddres() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        content: Container(
          height: 200,
          child: Column(
            children: [
              Text(
                "Antes de começar\nvamos definir seu endereço...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              Center(
                child: AnimatedButton(
                  height: 50,
                  color: Colors.red,
                  child: Text(
                    'Ok, vamos lá!',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    Timer(Duration(milliseconds: 500), () {
                      pageTransition(
                        context: context,
                        screen: new RegisterAddressScreen(),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
