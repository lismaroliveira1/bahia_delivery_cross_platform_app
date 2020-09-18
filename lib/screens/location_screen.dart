import 'package:bahia_delivery/blocs/search_bloc.dart';
import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/services/location_service.dart';
import 'package:bahia_delivery/widgets/address_card.dart';
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
  var searchBloc = SearchBloc();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (model.latitude == null || model.longittude == null) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.red[400]),
            ),
          ),
        );
      } else {
        return Scaffold(
          key: homeScaffoldKey,
          body: Form(
            key: formKey,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
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
                          final SearchAdress searchAdress = SearchAdress();
                          await searchAdress.getAddressFromLatLng(
                              lat: model.latitude, lng: model.longittude);
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(child: AddressCard());
                              });
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
      }
    });
  }
}
