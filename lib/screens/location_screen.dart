import 'package:bahia_delivery/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    super.initState();
    String apiKey = "AIzaSyB9QAT4C-TwvJu8pmNMxbRnGp_am3j76xI";
    googlePlace = GooglePlace(apiKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          child: Stack(
            children: [
              Container(
                color: Colors.green,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[Container()],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20, top: 100),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
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
                    Expanded(
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
                              print(predictions[index]
                                  .structuredFormatting
                                  .mainText); // street
                              var result =
                                  await googlePlace.search.getNearBySearch(
                                Location(
                                  lat: UserModel.of(context).latitude,
                                  lng: UserModel.of(context).longittude,
                                ),
                                1,
                              );
                              if (result != null) {
                                print("ok");
                                print(result.results.first.placeId);
                                var userLocations = await googlePlace.details
                                    .get(result.results.last.placeId);
                                if (userLocations != null) {
                                  print(userLocations.result.formattedAddress);
                                }
                              }
                              debugPrint(predictions[index]
                                  .description
                                  .replaceAll("State of", ""));
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
