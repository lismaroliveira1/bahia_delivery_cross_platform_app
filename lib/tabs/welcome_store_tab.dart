import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/cart_screen.dart';
import 'package:bd_app_full/screens/category_store_screen.dart';
import 'package:bd_app_full/screens/product_screen.dart';
import 'package:bd_app_full/tiles/purchased_products_tile.dart';
import 'package:bd_app_full/tiles/store_combo_tile.dart';
import 'package:bd_app_full/tiles/store_off_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class WelcomeStoreTab extends StatefulWidget {
  final StoreData storeData;
  WelcomeStoreTab({
    @required this.storeData,
  });
  @override
  _WelcomeStoreTabState createState() => _WelcomeStoreTabState();
}

class _WelcomeStoreTabState extends State<WelcomeStoreTab> {
  List<ProductData> purchasedProducts = [];
  double distance;
  double serviceTime;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      distance = Geolocator.distanceBetween(
        widget.storeData.latLng.latitude,
        widget.storeData.latLng.longitude,
        model.latLngDevice.latitude,
        model.latLngDevice.longitude,
      );
      serviceTime = ((distance / 1000) / 30) * 60 + widget.storeData.setupTime;
      return Container(
        child: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    elevation: 8,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    expandedHeight: MediaQuery.of(context).size.height * 0.2,
                    floating: true,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Container(
                        child: Text(
                          widget.storeData.name,
                          style: GoogleFonts.fredokaOne(
                            color: Colors.grey,
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      background: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[400],
                                blurRadius: 1.0, // soften the shadow
                                spreadRadius: 1.0, //extend the shadow
                                offset: Offset(
                                  2.0, // Move to right 10  horizontally
                                  2.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ],
                          ),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: widget.storeData.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.alarm,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                      ),
                                      child: Text(
                                          '${serviceTime.toStringAsFixed(0)} min'),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 4,
                                      ),
                                      child: Text(
                                          "Frete: R\$ ${(widget.storeData.deliveryRate * distance / 1000).toStringAsFixed(2)}"),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Center(
                                child: Container(
                                  child: Text(widget.storeData.description),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      widget.storeData.discount > 0
                          ? Container(
                              height: 30,
                              color: Colors.grey,
                              child:
                                  Text("Cupon de ${widget.storeData.discount}"),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      widget.storeData.productsOff.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(left: 12, top: 10),
                              child: Text(
                                "Promoções",
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      widget.storeData.productsOff.length > 0
                          ? Container(
                              height: 180,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children:
                                    widget.storeData.productsOff.map((off) {
                                  return StoreOffTile(
                                    widget.storeData,
                                    off,
                                  );
                                }).toList(),
                              ),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      widget.storeData.storesCombos.length > 0
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        top: 10,
                                      ),
                                      child: Text(
                                        "Combos",
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 200,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: widget.storeData.storesCombos
                                        .map((combo) {
                                      return StoreComboTile(
                                        combo,
                                        widget.storeData,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                      widget.storeData.purchasedProducts.length > 0
                          ? Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 12, top: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Peça novamente...",
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 2.0,
                                  ),
                                  child: Container(
                                    height: 140,
                                    child: ListView(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        children: widget
                                            .storeData.purchasedProducts
                                            .map(
                                              (purchased) => FlatButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    new PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeft,
                                                      child:
                                                          new ProductStoreScreen(
                                                        purchased,
                                                        widget.storeData,
                                                      ),
                                                      inheritTheme: true,
                                                      duration: new Duration(
                                                        milliseconds: 350,
                                                      ),
                                                      ctx: context,
                                                    ),
                                                  );
                                                },
                                                child:
                                                    PurchasedProduct(purchased),
                                              ),
                                            )
                                            .toList()),
                                  ),
                                )
                              ],
                            )
                          : Container(),
                    ]),
                  )
                ];
              },
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 10),
                    child: Row(
                      children: [
                        Text(
                          "Seções",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StaggeredGridView.count(
                      padding: EdgeInsets.zero,
                      crossAxisCount: 2,
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 3.0,
                      staggeredTiles:
                          widget.storeData.storeCategoryList.map((category) {
                        return StaggeredTile.count(
                          category.x,
                          category.y + 0.2 * category.y,
                        );
                      }).toList(),
                      children: widget.storeData.storeCategoryList.map(
                        (category) {
                          double width;
                          double height;
                          height =
                              (MediaQuery.of(context).size.width * 0.95 * 0.5) *
                                  category.y;
                          width =
                              (MediaQuery.of(context).size.width * 0.95 * 0.5) *
                                  category.x;
                          return FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            child: Card(
                              elevation: 4,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: CategoryStoreScreen(
                                        widget.storeData,
                                        category.id,
                                      ),
                                      inheritTheme: true,
                                      duration: Duration(
                                        milliseconds: 350,
                                      ),
                                      ctx: context,
                                    ),
                                  );
                                },
                                padding: EdgeInsets.zero,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                          vertical: 2.0,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.network(
                                            category.image,
                                            fit: BoxFit.cover,
                                            height: height,
                                            width: width,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                          vertical: 2.0,
                                        ),
                                        child: Text(
                                          category.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                          vertical: 2.0,
                                        ),
                                        child: Text(
                                          category.description,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: ScopedModelDescendant<UserModel>(
                builder: (context, child, model) {
                  if (model.hasProductInCart) {
                    return FloatingActionButton(
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: CartScreen(widget.storeData),
                            inheritTheme: true,
                            duration: Duration(
                              milliseconds: 500,
                            ),
                            ctx: context,
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
