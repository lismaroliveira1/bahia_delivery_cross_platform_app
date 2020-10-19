import 'package:bahia_delivery/data/address_data_from_google.dart';
import 'package:bahia_delivery/models/address_model.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:scoped_model/scoped_model.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int textLenght;
  GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    String apiKey = "AIzaSyB9QAT4C-TwvJu8pmNMxbRnGp_am3j76xI";
    googlePlace = GooglePlace(apiKey);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AddressModel>(
        builder: (context, child, model) {
      return Scaffold(
        body: SafeArea(
          child: Form(
            child: Stack(
              children: [
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 2.2,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20, left: 20, top: 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: "Meu Local",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey[350],
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.black54,
                              width: 2.0,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            textLenght = value.length;
                          });
                          if (value.isNotEmpty) {
                            autoCompleteSearch(value);
                          } else {
                            if (predictions.length > 0 && mounted) {
                              setState(() {
                                predictions = [];
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      textLenght == 0
                          ? Container(
                              height: 0,
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: predictions.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.red[50],
                                      child: Icon(
                                        Icons.pin_drop,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(predictions[index]
                                        .description
                                        .replaceAll("State of", "")),
                                    onTap: () async {
                                      final addressData = AddressDataFromGoogle(
                                        description:
                                            predictions[index].description,
                                        id: predictions[index].id,
                                        placeId: predictions[index].placeId,
                                        reference: predictions[index].reference,
                                      );
                                      model.getAddress(addressData);

                                      print(predictions[index]
                                          .structuredFormatting
                                          .mainText); // street
                                      var result = await googlePlace.search
                                          .getNearBySearch(
                                        Location(
                                          lat: UserModel.of(context).latitude,
                                          lng: UserModel.of(context).longittude,
                                        ),
                                        1,
                                      );
                                      if (result != null) {
                                        print("ok");
                                        print(result.results.first.placeId);
                                        var userLocations = await googlePlace
                                            .details
                                            .get(result.results.last.placeId);
                                        if (userLocations != null) {
                                          print(userLocations
                                              .result.formattedAddress);
                                        }
                                      }
                                      debugPrint(
                                        predictions[index]
                                            .description
                                            .replaceAll("State of", ""),
                                      );
                                      addressController.clear();
                                      textLenght = 0;
                                    },
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void autoCompleteSearch(String value) async {
    print(value);
    var result = await googlePlace.autocomplete.get(value);
    print(result.status);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }
}
