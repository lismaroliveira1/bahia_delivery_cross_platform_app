import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/screens/editer_address_screem.dart';
import 'package:bahia_delivery/screens/login_screen.dart';
import 'package:bahia_delivery/tiles/address_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

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
      } else if (!UserModel.of(context).isLoggedIn()) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(right: 130, left: 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.location_on,
                size: 80.0,
                color: Colors.red,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                "Faça login para adcionar seus endereços",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 55,
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                    },
                  ),
                ),
              )
            ],
          ),
        );
      } else if (model.addresses == null || model.addresses.length == 0) {
        return Scaffold(
          key: homeScaffoldKey,
          body: Form(
            key: formKey,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(model.latitude, model.longittude),
                        zoom: 16.0),
                    zoomGesturesEnabled: true,
                    myLocationEnabled: true,
                  ),
                ),
                AlertDialog(
                  title: Container(
                    height: 80,
                    width: 80,
                    child: Image.asset('images/logo.png'),
                  ),
                  content: Text(
                    "Gostaria utilizar a sua\n posição atual?",
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () {},
                        child: Text(
                          "Buscar pelo CEP",
                          textAlign: TextAlign.center,
                        )),
                    FlatButton(
                        onPressed: () async {
                          await model.getAddressFromLatLng(
                              lat: model.latitude, lng: model.longittude);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterAdrressScreeen()));
                        },
                        child: Text("Ok"))
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 5,
                  child: Center(
                    child: Container(
                        height: 42,
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width / 1.3,
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.redAccent,
            title: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: EdgeInsets.only(left: 18, right: 18),
                color: Colors.white,
                child: TextFormField(
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'CEP',
                    hintText: '12345-678',
                  ),
                ),
              ),
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
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(model.latitude, model.longittude),
                      zoom: 20.0),
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                ),
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
