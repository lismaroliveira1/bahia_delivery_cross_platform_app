import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_place/google_place.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/models.dart';

class RegisterAddressTab extends StatefulWidget {
  @override
  _RegisterAddressTabState createState() => _RegisterAddressTabState();
}

class _RegisterAddressTabState extends State<RegisterAddressTab> {
  final places =
      new GoogleMapsPlaces(apiKey: "AIzaSyB9QAT4C-TwvJu8pmNMxbRnGp_am3j76xI");
  int textLenght = 0;
  GooglePlace googlePlace;
  bool isSeted = false;
  List<AutocompletePrediction> predictions = [];
  final TextEditingController addressController = TextEditingController();
  bool close = false;
  Timer _timer;
  @override
  void initState() {
    String apiKey = "AIzaSyB9QAT4C-TwvJu8pmNMxbRnGp_am3j76xI";
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    if (close) {
      Navigator.of(buildContext).pop();
    }
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (model.isLoading == true) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return Scaffold(
          body: SafeArea(
            child: Form(
              child: Stack(
                children: [
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
                            ? Expanded(
                                child: ListView.builder(
                                itemCount: model.userAddress.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      model.setAddressWithoutSaving(
                                        initLoad: _initLoad,
                                        onFail: _onFail,
                                        onSuccess: _onSuccess,
                                        address:
                                            model.userAddress[index].address,
                                        lat: model.userAddress[index].lat,
                                        lng: model.userAddress[index].lng,
                                        addressId:
                                            model.userAddress[index].addressId,
                                      );
                                    },
                                    leading: Icon(
                                      Icons.location_city,
                                    ),
                                    title:
                                        Text(model.userAddress[index].address),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {},
                                    ),
                                  );
                                },
                              ))
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: predictions.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 1,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 2,
                                              ),
                                              color: Colors.white,
                                            ),
                                            child: ListTile(
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
                                                PlacesDetailsResponse response =
                                                    await places
                                                        .getDetailsByPlaceId(
                                                  predictions[index].placeId,
                                                );
                                                addressController.clear();
                                                UserModel.of(context)
                                                    .setAddressToRegister(
                                                  initLoad: _initLoad,
                                                  onFail: _onFail,
                                                  onSuccess: _onSuccess,
                                                  address: predictions[index]
                                                      .description
                                                      .replaceAll(
                                                          "State of", ""),
                                                  lat: response.result.geometry
                                                      .location.lat,
                                                  lng: response.result.geometry
                                                      .location.lng,
                                                  addressId: predictions[index]
                                                      .placeId,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
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
    });
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }

  void closeTab() {
    Timer(Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  void _onSuccess() async {
    setState(() {
      textLenght = 0;
    });
    await EasyLoading.dismiss();
    closeTab();
  }

  void _onFail() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Algo saiu errado, tente novamente",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _initLoad() async {
    _timer?.cancel();
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
  }
}
