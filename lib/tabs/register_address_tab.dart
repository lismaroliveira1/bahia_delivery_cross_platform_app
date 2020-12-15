import 'package:bd_app_full/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterAddressTab extends StatefulWidget {
  @override
  _RegisterAddressTabState createState() => _RegisterAddressTabState();
}

class _RegisterAddressTabState extends State<RegisterAddressTab> {
  int textLenght = 0;
  GooglePlace googlePlace;
  bool isSeted = false;
  List<AutocompletePrediction> predictions = [];
  final TextEditingController addressController = TextEditingController();
  bool close = false;

  @override
  void initState() {
    super.initState();
    String apiKey = "AIzaSyB9QAT4C-TwvJu8pmNMxbRnGp_am3j76xI";
    googlePlace = GooglePlace(apiKey);
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
                            ? Container(
                                height: 0,
                              )
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
                                                addressController.clear();
                                                setState(() {
                                                  textLenght = 0;
                                                });
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
    print(value);
    var result = await googlePlace.autocomplete.get(value);

    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }

  void _onSuccess() {}
  void _onFail() {}
}
