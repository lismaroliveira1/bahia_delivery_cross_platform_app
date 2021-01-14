import 'dart:async';

import 'package:animated_button/animated_button.dart';
import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:bd_app_full/screens/register_address_screen.dart';
import 'package:bd_app_full/screens/welcome_store_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';

class StoreHomeTile extends StatefulWidget {
  final StoreData storeData;
  StoreHomeTile(this.storeData);
  @override
  _StoreHomeTileState createState() => _StoreHomeTileState();
}

class _StoreHomeTileState extends State<StoreHomeTile> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
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
                          type: PageTransitionType.rightToLeft,
                          child: WelcomeStoreScreen(widget.storeData),
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
                height: 120,
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
                        borderRadius: BorderRadius.circular(8),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: widget.storeData.image,
                          height: 110,
                          width: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.storeData.name,
                            style: GoogleFonts.fredokaOne(
                              color: Colors.black45,
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            widget.storeData.description,
                            style: GoogleFonts.notoSans(),
                          ),
                          widget.storeData.deliveryTime != null
                              ? Text(
                                  "${widget.storeData.deliveryTime.toStringAsFixed(0)} m",
                                )
                              : Container(
                                  height: 0,
                                ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: IconButton(
                onPressed: () {
                  model.addRemoveStoreFavorite(
                    storeId: widget.storeData.id,
                  );
                },
                icon: Icon(
                  Icons.favorite,
                  size: 20,
                  color: widget.storeData.isFavorite
                      ? Colors.red[200]
                      : Colors.grey,
                ),
              ),
            ),
            widget.storeData.discount > 0
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
                          "-${widget.storeData.discount.toStringAsFixed(0)}",
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
    });
  }

  void loadAddres() {
    Scaffold.of(context).showSnackBar(
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
                    Scaffold.of(context).hideCurrentSnackBar();
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
          ),
        ),
      ),
    );
  }
}
