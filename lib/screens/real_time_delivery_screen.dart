import 'dart:async';

import 'package:animated_button/animated_button.dart';
import 'package:bd_app_full/data/combo_data.dart';
import 'package:bd_app_full/data/order_data.dart';
import 'package:bd_app_full/data/product_data.dart';
import 'package:bd_app_full/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:location/location.dart';
import 'package:transparent_image/transparent_image.dart';

class RealTimeDeliveryScreen extends StatefulWidget {
  final OrderData orderData;
  RealTimeDeliveryScreen(this.orderData);
  @override
  _RealTimeDeliveryScreenState createState() => _RealTimeDeliveryScreenState();
}

class _RealTimeDeliveryScreenState extends State<RealTimeDeliveryScreen> {
  String _instruction = "";

  bool isDeliverySending;
  List<ProductData> products = [];
  MapBoxNavigation _directions;
  MapBoxOptions _options;
  bool _arrived = false;
  bool _isMultipleStop = false;
  double _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  LocationData _locationData;
  Location location = new Location();
  String longitudeText = '';
  String latitudeText = '';
  bool _navigationFinished;
  List<WayPoint> wayPoints = [];
  bool orderFinished;

  @override
  void initState() {
    if (widget.orderData.status == 4) {
      orderFinished = true;
    } else {
      orderFinished = false;
    }
    super.initState();
    getDeviceLocation();
    initialize();
    _navigationFinished = false;
    isDeliverySending = false;
  }

  Future<void> initialize() async {
    if (!mounted) return;
    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
    _options = MapBoxOptions(
      initialLatitude: 36.1175275,
      initialLongitude: -115.1839524,
      zoom: 15.0,
      tilt: 0.0,
      bearing: 0.0,
      enableRefresh: false,
      alternatives: true,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      allowsUTurnAtWayPoints: true,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      units: VoiceUnits.imperial,
      simulateRoute: false,
      animateBuildRoute: true,
      longPressDestinationEnabled: true,
      language: "pt",
    );
    location.onLocationChanged.listen((locationData) async {
      if (isDeliverySending) {
        _distanceRemaining = await _directions.distanceRemaining;
        _durationRemaining = await _directions.durationRemaining;
      }
      UserModel.of(context).setLocationdDeliveryManOrder(
        orderData: widget.orderData,
        lat: locationData.latitude,
        lng: locationData.longitude,
        distanceRemaining: _distanceRemaining,
        durationRemaining: _durationRemaining,
        isSending: isDeliverySending,
      );
      setState(() {
        longitudeText = locationData.longitude.toStringAsFixed(8);
        latitudeText = locationData.latitude.toStringAsFixed(8);
      });
    });
    _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            collapsedHeight: 200,
            flexibleSpace: Center(
              child: Container(
                height: 170,
                width: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage('images/logo_and_name.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Pedido: ${widget.orderData.id.substring(0, 6)}",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      height: MediaQuery.of(context).size.height / 15,
                      width: MediaQuery.of(context).size.height / 15,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: widget.orderData.storeImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.orderData.storeName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Center(
                    child: Text(
                      "Itens",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  widget.orderData.products.length > 0
                      ? _buildProductsAndComplements(widget.orderData.products)
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                  widget.orderData.combos.length > 0
                      ? _buildComboText(widget.orderData.combos)
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: (Text(
                        orderFinished
                            ? 'Pedido Finalizado'
                            : _instruction == null || _instruction.isEmpty
                                ? "Localização atual"
                                : _instruction,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  !orderFinished
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20, top: 20, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("Tempo estimado: "),
                                  Text(_durationRemaining != null
                                      ? "${(_durationRemaining / 60).toStringAsFixed(0)} minutes"
                                      : "---")
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text("Distancia: "),
                                  Text(_distanceRemaining != null
                                      ? "${(_distanceRemaining / 1000).toStringAsFixed(1)} Km"
                                      : "---")
                                ],
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                  !orderFinished
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 200,
                            color: Colors.grey,
                            child: MapBoxNavigationView(
                              options: _options,
                              onRouteEvent: _onEmbeddedRouteEvent,
                              onCreated: (MapBoxNavigationViewController
                                  controller) async {
                                _controller = controller;
                                controller.initialize();
                              },
                            ),
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                  !orderFinished
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Center(
                            child: AnimatedButton(
                              color: Colors.red,
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: 40,
                              onPressed: () async {
                                final userOrigin = WayPoint(
                                  name: "Way Point 3",
                                  latitude: _locationData.latitude,
                                  longitude: _locationData.longitude,
                                );
                                final _stop1 = WayPoint(
                                  name: "Way Point 2",
                                  latitude: widget.orderData.clientLat,
                                  longitude: widget.orderData.clientLng,
                                );
                                wayPoints.add(userOrigin);
                                wayPoints.add(_stop1);
                                UserModel.of(context).setStatusOrder(
                                  orderData: widget.orderData,
                                  status: 2,
                                );
                                setState(() {
                                  isDeliverySending = true;
                                });
                                await _directions.startNavigation(
                                  wayPoints: wayPoints,
                                  options: MapBoxOptions(
                                    mode: MapBoxNavigationMode.walking,
                                    simulateRoute: false,
                                    language: "pt",
                                    allowsUTurnAtWayPoints: true,
                                    units: VoiceUnits.metric,
                                  ),
                                );
                              },
                              child: Text(
                                'Entregar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Center(
                      child: AnimatedButton(
                        color: _navigationFinished && !orderFinished
                            ? Colors.red
                            : Colors.grey,
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 40,
                        onPressed: _navigationFinished && !orderFinished
                            ? () async {
                                await FirebaseFirestore.instance
                                    .collection("orders")
                                    .doc(widget.orderData.id)
                                    .update({
                                  "status": 4,
                                  "isFinished": true,
                                });
                              }
                            : null,
                        child: Text(
                          orderFinished ? 'Pedido\nFinalizado' : 'Finalizar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await _directions.distanceRemaining;
    _durationRemaining = await _directions.durationRemaining;
    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        _arrived = progressEvent.arrived;

        if (progressEvent.currentStepInstruction != null)
          _instruction = progressEvent.currentStepInstruction;
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
          isDeliverySending = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
          isDeliverySending = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        _arrived = true;
        if (!_isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
        setState(() {
          _navigationFinished = true;
        });
        break;
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }

  void getDeviceLocation() async {
    _locationData = await location.getLocation();
  }

  Widget _buildComboText(List<ComboData> comboList) {
    return Column(
      children: comboList
          .map(
            (combo) => Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(
                    combo.quantity.toString() +
                        " x " +
                        combo.title +
                        " (R\$ ${combo.price.toStringAsFixed(2)})",
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "R\$ ${(combo.price * combo.quantity).toStringAsFixed(2)}",
                    ),
                  ],
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildProductsAndComplements(List<ProductData> productsList) {
    products.clear();
    for (ProductData product in productsList) {
      products.add(product);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: products.map((product) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(
            product.quantity.toString() +
                " x " +
                product.productTitle +
                " (R\$ ${product.productPrice})",
            textAlign: TextAlign.center,
          ),
          subtitle: product.complementProducts.length > 0
              ? Column(
                  children: [
                    Text(
                      "Complementos:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: product.complementProducts.map((complement) {
                        return Text(
                          complement.quantity.toString() +
                              " x " +
                              complement.title +
                              " (R\$ ${complement.price.toStringAsFixed(2)})",
                        );
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("R\$ ${product.totalPrice.toStringAsFixed(2)}"),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("R\$ ${product.totalPrice.toStringAsFixed(2)}"),
                      ],
                    ),
                  ],
                ),
        );
      }).toList(),
    );
  }
}
