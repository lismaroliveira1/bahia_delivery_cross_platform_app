import 'package:bd_app_full/components/components.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

import '../data/data.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class CategoryStoreTab extends StatefulWidget {
  final StoreData storeData;
  final CategoryStoreData categoryStoreData;
  CategoryStoreTab(this.storeData, this.categoryStoreData);
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
            delegate: SliverChildListDelegate(
              [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 5,
                    ),
                    child: Text(
                      widget.categoryStoreData.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.categoryStoreData.image,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          )
        ];
      },
      body: Stack(
        children: [
          Container(
            child: GroupedListView<dynamic, String>(
              elements: widget.storeData.products
                  .where(
                    (element) =>
                        element.categoryId == widget.categoryStoreData.id,
                  )
                  .toList(),
              padding: EdgeInsets.zero,
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
                doc.storeId = widget.storeData.id;
                return Card(
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      child: ListTile(
                        onTap: () {
                          pageTransition(
                            context: context,
                            screen: ProductStoreScreen(doc, widget.storeData),
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
            bool hasProductInCart = false;
            model.cartDataList.forEach((element) {
              if (element.storeData.id == widget.storeData.id) {
                hasProductInCart = true;
              }
            });
            if (model.isLoading) {
              return Container(
                height: 0,
                width: 0,
              );
            } else {
              if (model.cartProducts.length > 0 && hasProductInCart) {
                return Positioned(
                  bottom: 0,
                  child: FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      pageTransition(
                        context: context,
                        screen: CartScreen(widget.storeData),
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
