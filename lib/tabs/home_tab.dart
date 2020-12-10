import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/welcome_store_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String permissionStatus;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
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
                            onPressed: () {},
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
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: WelcomeStoreScreen(store),
                                      inheritTheme: true,
                                      duration: Duration(
                                        milliseconds: 350,
                                      ),
                                      ctx: context,
                                    ),
                                  );
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
                              )
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
}
