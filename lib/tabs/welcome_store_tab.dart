import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/cart_screen.dart';
import 'package:bd_app_full/screens/category_store_screen.dart';
import 'package:bd_app_full/screens/combo_screnn.dart';
import 'package:bd_app_full/screens/product_screen.dart';
import 'package:bd_app_full/screens/sales_off_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class WelcomeStoreTab extends StatefulWidget {
  final StoreData storeData;
  WelcomeStoreTab(this.storeData);
  @override
  _WelcomeStoreTabState createState() => _WelcomeStoreTabState();
}

class _WelcomeStoreTabState extends State<WelcomeStoreTab> {
  List<ProductData> purchasedProducts = [];
  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                expandedHeight: 200.0,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.storeData.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 14,
                      ),
                      child: Text(
                        widget.storeData.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(widget.storeData.description),
                  ),
                  widget.storeData.productsOff.length > 0
                      ? Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            "Promoções",
                            style: TextStyle(
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
                          height: 160,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: widget.storeData.productsOff.map((off) {
                              double imageSize =
                                  MediaQuery.of(context).size.width / 4;
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: SalesOffScreen(
                                          widget.storeData,
                                          off,
                                        ),
                                        inheritTheme: true,
                                        duration: Duration(
                                          milliseconds: 350,
                                        ),
                                        ctx: context,
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: imageSize,
                                        width: imageSize,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: new DecorationImage(
                                            image: NetworkImage(
                                              off.image,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        off.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(off.description),
                                    ],
                                  ),
                                ),
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
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    "Combos",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 160,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children:
                                    widget.storeData.storesCombos.map((combo) {
                                  double imageSize =
                                      MediaQuery.of(context).size.width / 4;
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: ComboStoreScreen(
                                              combo,
                                              widget.storeData,
                                            ),
                                            inheritTheme: true,
                                            duration: Duration(
                                              milliseconds: 350,
                                            ),
                                            ctx: context,
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: imageSize,
                                            width: imageSize,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: new DecorationImage(
                                                image: NetworkImage(
                                                  combo.image,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            combo.title,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            combo.description,
                                          ),
                                        ],
                                      ),
                                    ),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 2.0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Peça novamente...",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
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
                                    scrollDirection: Axis.horizontal,
                                    children: widget.storeData.purchasedProducts
                                        .map(
                                          (purchased) => FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                new PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  child: new ProductStoreScreen(
                                                    purchased,
                                                  ),
                                                  inheritTheme: true,
                                                  duration: new Duration(
                                                    milliseconds: 350,
                                                  ),
                                                  ctx: context,
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          purchased
                                                              .productImage,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(purchased.productTitle),
                                                  Text(
                                                      "R\$ ${purchased.productPrice.toStringAsFixed(2)}")
                                                ],
                                              ),
                                            ),
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
          body: StaggeredGridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 2,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 3.0,
            staggeredTiles: widget.storeData.storeCategoryList.map((category) {
              return StaggeredTile.count(
                category.x,
                category.y + 0.2 * category.y,
              );
            }).toList(),
            children: widget.storeData.storeCategoryList.map(
              (category) {
                double width;
                double height;
                height = (MediaQuery.of(context).size.width * 0.95 * 0.5) *
                    category.y;
                width = (MediaQuery.of(context).size.width * 0.95 * 0.5) *
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
                                borderRadius: BorderRadius.circular(6),
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
    );
  }
}
