import 'package:bahia_delivery/blocs/search_bloc.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/editer_address_screem.dart';
import 'package:bahia_delivery/screens/login_screen.dart';
import 'package:bahia_delivery/tiles/address_tile.dart';
import 'package:bahia_delivery/widgets/search_place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_plugin/place_plugin.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:place_plugin/place.dart';

const kGoogleApiKey = "AIzaSyBavlFX_n6MlAxfIPohHqu9n4F7zCvNpvg";

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      model.loadAddressItems();
      if (model.isLoading && UserModel.of(context).isLoggedIn() ||
          model.latitude == null ||
          model.longittude == null) {
        return Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        var searchBloc = SearchBlock();
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.redAccent,
            title: Column(
              children: [
                SearchPlace(
                  onChanged: (value) {
                    searchBloc.searchPlace(value);
                  },
                ),
                StreamBuilder(
                    stream: searchBloc.searchStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        if (snapshot.data == 'searching') {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<Place> places = snapshot.data;
                        return Container(
                          child: ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      Divider(),
                              itemBuilder: (BuildContext context, int index) {
                                Place place = places.elementAt(index);
                                return ListTile(
                                  title: Text(place.name),
                                  subtitle: Text(place.address),
                                  onTap: () {
                                    PlacePlugin.getPlace(place).then((place) {
                                      print(place.name);
                                      print(place.formatedAddress);
                                    });
                                  },
                                );
                              },
                              itemCount: places.length),
                        );
                      } else {
                        return Container(
                          height: 0,
                        );
                      }
                    }),
              ],
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  await model.getAddressFromLatLng(
                      lat: model.latitude, lng: model.longittude);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterAdrressScreeen()));
                },
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 2.2,
                color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView(
                children: model.addresses.map((address) {
                  return AddressTile(address);
                }).toList(),
              ))
            ],
          ),
        );
      }
    });
  }
}
