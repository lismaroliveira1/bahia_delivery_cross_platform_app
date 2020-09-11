import 'package:bahia_delivery/models/user_model.dart';
import 'package:bahia_delivery/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                Positioned(
                  top: MediaQuery.of(context).size.height / 5,
                  child: Center(
                    child: Container(
                        height: 42,
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment(0.0, 0.0),
                          child: Search(),
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
