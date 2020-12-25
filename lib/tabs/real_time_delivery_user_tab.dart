import 'dart:async';
import 'dart:collection';

import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class RealTimeDeliveryUserTab extends StatefulWidget {
  final OrderData orderData;

  RealTimeDeliveryUserTab(this.orderData);
  @override
  _RealTimeDeliveryUserTabState createState() =>
      _RealTimeDeliveryUserTabState();
}

class _RealTimeDeliveryUserTabState extends State<RealTimeDeliveryUserTab> {
  double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  double _destLatitude = 6.849660, _destLongitude = 3.648190;

  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = 'AIzaSyB9QAT4C-TwvJu8pmNMxbRnGp_am3j76xI';

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  LocationData currentLocation;
  double durationRemaining;
  double distanceRemaining;
  LocationData destinationLocation;
  int text;
  int status;
  double deliveryRealTimeLat;
  double deliveryRealTimeLng;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  Location location = Location();
  Set<Marker> _markers = HashSet<Marker>();
  FirebaseApp firebaseApp;
  FirebaseDatabase database;

  DatabaseReference _deliveryManRealTimeLocation;
  @override
  void initState() {
    status = 1;
    durationRemaining = 0;
    distanceRemaining = 0;
    _checkLocationPermission();
    realTimeInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
            )
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        "Pedido: ${widget.orderData.id.substring(0, 6)}",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width / 4,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.orderData.storeImage,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.orderData.storeName,
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.clip,
                                softWrap: true,
                              ),
                              Text(
                                widget.orderData.storeDescription,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.clip,
                                softWrap: true,
                              ),
                              Text(
                                "Total: R\$${(widget.orderData.totalPrice + widget.orderData.shipPrice).toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.clip,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FlatButton(
                            onPressed: () {
                              onProductListPressed();
                            },
                            child: Card(
                              elevation: 8,
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image:
                                        AssetImage('images/product_list.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.location_on),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.2),
                  child: Text(
                    "${widget.orderData.clientAddress}",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("orders")
                        .doc(widget.orderData.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int status = snapshot.data["status"];
                        if (snapshot.data['realTimeDeliveryManLocation'] !=
                            {}) {
                          deliveryRealTimeLat = snapshot
                              .data["realTimeDeliveryManLocation"]["lat"];
                          deliveryRealTimeLng = snapshot
                              .data["realTimeDeliveryManLocation"]["lng"];
                          UserModel.of(context).getRealTimeDeliveryManPosition(
                              lat: deliveryRealTimeLat,
                              lng: deliveryRealTimeLng);
                        }
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _buildCircle("1", "Preparação", status, 1),
                                Container(
                                  height: 1.0,
                                  width: 40.0,
                                  color: Colors.red,
                                ),
                                _buildCircle("2", "Transporte", status, 2),
                                Container(
                                  height: 1.0,
                                  width: 40.0,
                                  color: Colors.red,
                                ),
                                _buildCircle("3", "Entrega", status, 3),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Entregador",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
                ),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.width / 4,
                    width: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.orderData.deliveryManData.image,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    widget.orderData.deliveryManData.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              "Tempo: ${(durationRemaining / 60).toStringAsFixed(0)} min"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              "Distância: ${(distanceRemaining / 1000).toStringAsFixed(1)} Km"),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(25)),
                    child: GoogleMap(
                      scrollGesturesEnabled: true,
                      myLocationButtonEnabled: true,
                      compassEnabled: true,
                      markers: _markers,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          widget.orderData.clientLat,
                          widget.orderData.clientLng,
                        ),
                        zoom: 16,
                      ),
                      onMapCreated: (GoogleMapController mapController) {
                        _controller.complete(mapController);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;
    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check);
    }
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 16.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }

  void _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  void realTimeInit() async {
    _deliveryManRealTimeLocation = FirebaseDatabase.instance
        .reference()
        .child("orders")
        .child(widget.orderData.id)
        .child("deliveryRealTimeLocation");
    _deliveryManRealTimeLocation.onValue.listen((event) async {
      setState(() {
        distanceRemaining = event.snapshot.value["distanceRemaining"];
        durationRemaining = event.snapshot.value["durationRemaining"];
      });
      showMarkers(
        lat: event.snapshot.value['lat'],
        lng: event.snapshot.value['lng'],
      );
    });
  }

  void showMarkers({
    @required double lat,
    @required double lng,
  }) async {
    Set<Marker> flag = HashSet<Marker>();
    flag.clear();
    flag.add(
      Marker(
        markerId: MarkerId("destinationId"),
        position: LatLng(
          lat,
          lng,
        ),
      ),
    );
    flag.add(
      Marker(
        markerId: MarkerId("sourceId"),
        position: LatLng(
          widget.orderData.clientLat,
          widget.orderData.clientLng,
        ),
      ),
    );
    setState(() {
      _markers = flag;
    });
    CameraPosition cPosition = CameraPosition(
      tilt: 60,
      bearing: CAMERA_BEARING,
      target: LatLng(
        lat,
        lng,
      ),
      zoom: 18,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  void onProductListPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        duration: Duration(minutes: 1),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      "Produtos",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: widget.orderData.products
                          .map(
                            (product) => Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    product.productTitle,
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${product.quantity.toStringAsFixed(0)} x ${product.productPrice}",
                                    style: TextStyle(
                                      color: Colors.black38,
                                    ),
                                  ),
                                  trailing: Text(
                                    "R\$${product.totalPrice.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: Colors.black38,
                                    ),
                                  ),
                                  leading: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          product.productImage,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Taxa de entrega: R\$ ${widget.orderData.shipPrice.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Total: R\$ ${widget.orderData.totalPrice.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 2,
                top: 2,
                child: IconButton(
                  icon: Icon(
                    Icons.close_fullscreen_rounded,
                    color: Colors.black54,
                    size: 15,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
