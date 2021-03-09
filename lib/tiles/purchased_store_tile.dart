import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/data.dart';

class PurchasedStoreTile extends StatefulWidget {
  final StoreData storeData;
  PurchasedStoreTile(this.storeData);
  @override
  _PurchasedStoreTileState createState() => _PurchasedStoreTileState();
}

class _PurchasedStoreTileState extends State<PurchasedStoreTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            blurRadius: 1.0, // soften the shadow
            spreadRadius: 1.0, //extend the shadow
            offset: Offset(
              2.0, // Move to right 10  horizontally
              2.0, // Move to bottom 10 Vertically
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 6.0,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: new DecorationImage(
                    image: NetworkImage(
                      widget.storeData.image,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Text(
            widget.storeData.name,
            style: GoogleFonts.fredokaOne(
              color: Colors.black45,
            ),
          ),
          Text(
            "Categoria",
            style: GoogleFonts.notoSans(),
          ),
        ],
      ),
    );
  }
}
