import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/cart_screen.dart';
import 'package:bd_app_full/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryStoreTab extends StatefulWidget {
  final StoreData storeData;
  final String categoryId;
  CategoryStoreTab(this.storeData, this.categoryId);
  @override
  _CategoryStoreTabState createState() => _CategoryStoreTabState();
}

class _CategoryStoreTabState extends State<CategoryStoreTab> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
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
            ]),
          )
        ];
      },
      body: Stack(
        children: [
          Container(
            child: GroupedListView<dynamic, String>(
              elements: widget.storeData.products
                  .where(
                    (element) => element.categoryId == widget.categoryId,
                  )
                  .toList(),
              groupBy: (element) => element.group,
              useStickyGroupSeparators: false,
              groupSeparatorBuilder: (String value) => Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        10.0,
                        5.0,
                        2.0,
                        6.0,
                      ),
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              itemBuilder: (c, doc) {
                return Card(
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: ProductStoreScreen(doc),
                              inheritTheme: true,
                              duration: Duration(
                                milliseconds: 350,
                              ),
                              ctx: context,
                            ),
                          );
                        },
                        dense: false,
                        leading: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: doc.productImage,
                              fit: BoxFit.fill,
                              height: 80,
                              width: 60,
                            ),
                          ),
                        ),
                        title: Text(doc.productTitle),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.productDescription.toString().length < 40
                                  ? doc.productDescription
                                  : doc.productDescription
                                          .toString()
                                          .substring(0, 40) +
                                      "...",
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'R' +
                                      '\$ ' +
                                      doc.productPrice
                                          .toString()
                                          .replaceAll(".", ","),
                                  style: TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ScopedModelDescendant<UserModel>(builder: (context, child, model) {
            if (model.isLoading) {
              return Container(
                height: 0,
                width: 0,
              );
            } else {
              if (model.cartProducts.length > 0) {
                return Positioned(
                  bottom: 0,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
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
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          "Voce tem produtos no carrinho",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  height: 0,
                  width: 0,
                );
              }
            }
          })
        ],
      ),
    );
  }
}
