import 'package:bd_app_full/data/combo_data.dart';
import 'package:bd_app_full/data/store_data.dart';
import 'package:bd_app_full/screens/combo_screnn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class StoreComboTile extends StatefulWidget {
  final ComboData combo;
  final StoreData storeData;
  StoreComboTile(this.combo, this.storeData);
  @override
  _StoreComboTileState createState() => _StoreComboTileState();
}

class _StoreComboTileState extends State<StoreComboTile> {
  ComboData combo;
  StoreData storeData;
  @override
  void initState() {
    combo = widget.combo;
    storeData = widget.storeData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width / 3.5;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: ComboStoreScreen(
                combo,
                storeData,
              ),
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
          child: Padding(
            padding: const EdgeInsets.all(2.0),
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
                        combo.image,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  combo.title,
                  style: GoogleFonts.patrickHand(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  combo.description,
                ),
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
                      "-${combo.discountPercentage.toStringAsFixed(0)}%",
                      style: GoogleFonts.patrickHand(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
