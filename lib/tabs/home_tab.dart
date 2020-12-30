import 'dart:async';

import 'package:animated_button/animated_button.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/register_address_screen.dart';
import 'package:bd_app_full/screens/welcome_store_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String permissionStatus;
  bool isAddressSeted;

  void initState() {
    Permission.locationWhenInUse.serviceStatus.isEnabled.then((value) async {
      await Permission.locationWhenInUse.request();
    });
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
                  expandedHeight: 100,
                  flexibleSpace: Container(
                    height: 100,
                    margin: EdgeInsets.only(top: 65),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: Icon(
                              Icons.sort,
                            ),
                          ),
                          Image.asset(
                            "images/logo.png",
                            width: 85,
                            height: 85,
                            fit: BoxFit.cover,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: model.userData.image,
                              height: 40,
                              width: 40,
                              fit: BoxFit.fill,
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
                            Navigator.push(
                              context,
                              new PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: new RegisterAddressScreen(),
                                inheritTheme: true,
                                duration: new Duration(
                                  milliseconds: 350,
                                ),
                                ctx: context,
                              ),
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
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: WelcomeStoreScreen(
                                                purchasedStore),
                                            inheritTheme: true,
                                            duration: Duration(
                                              milliseconds: 350,
                                            ),
                                            ctx: context,
                                          ),
                                        );
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
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6.0,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0),
                                                child: Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    image: new DecorationImage(
                                                      image: NetworkImage(
                                                        purchasedStore.image,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              purchasedStore.name,
                                            ),
                                          ],
                                        ),
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
                          if (coupon.discount > store.discount &&
                              coupon.start.isBefore(DateTime.now())) {
                            store.discount = coupon.discount;
                          }
                        });
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Stack(
                            children: [
                              FlatButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  model.addressSeted
                                      ? Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: WelcomeStoreScreen(store),
                                            inheritTheme: true,
                                            duration: Duration(
                                              milliseconds: 350,
                                            ),
                                            ctx: context,
                                          ),
                                        )
                                      : loadAddres();
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[300],
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image: store.image,
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              store.name,
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              store.description,
                                            ),
                                            store.deliveryTime != null
                                                ? Text(
                                                    "${store.deliveryTime.toStringAsFixed(0)} m",
                                                  )
                                                : Container(
                                                    height: 0,
                                                  ),
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: IconButton(
                                  onPressed: () {
                                    model.addRemoveStoreFavorite(
                                      storeId: store.id,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    size: 20,
                                    color: store.isFavorite
                                        ? Colors.red[200]
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                              store.discount > 0
                                  ? Positioned(
                                      right: 8,
                                      bottom: 8,
                                      child: Container(
                                        height: 15,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          color: Colors.green[600],
                                          border: Border.all(
                                            color: Colors.green[600],
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "-${store.discount.toStringAsFixed(0)}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    ),
                            ],
                          ),
                        );
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
                        Navigator.push(
                          context,
                          new PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: new RegisterAddressScreen(),
                            inheritTheme: true,
                            duration: new Duration(
                              milliseconds: 350,
                            ),
                            ctx: context,
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
