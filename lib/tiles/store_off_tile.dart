import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/data.dart';
import '../screens/screens.dart';

import '../data/data.dart';
import '../screens/screens.dart';

class StoreOffTile extends StatefulWidget {
  final StoreData storeData;
  final OffData off;
  StoreOffTile(this.storeData, this.off);
  @override
  _StoreOffTileState createState() => _StoreOffTileState();
}

class _StoreOffTileState extends State<StoreOffTile> {
  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width / 3.5;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FlatButton(
        onPressed: () => SalesOffScreen(
          widget.storeData,
          widget.off,
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300],
            ),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: imageSize,
                width: imageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: new DecorationImage(
                    image: NetworkImage(
                      widget.off.image,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                widget.off.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(widget.off.description),
              Container(
                width: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    "-${widget.off.discountPercentage.toStringAsFixed(0)}%",
                    style: GoogleFonts.patrickHand(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
