import 'package:animated_button/animated_button.dart';
import 'package:bd_app_full/data/order_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:location/location.dart';

class RealTimeDeliveryScreen extends StatefulWidget {
  final OrderData orderData;
  RealTimeDeliveryScreen(this.orderData);
  @override
  _RealTimeDeliveryScreenState createState() => _RealTimeDeliveryScreenState();
}

class _RealTimeDeliveryScreenState extends State<RealTimeDeliveryScreen> {
  String _instruction = "";
  final _origin = WayPoint(
      name: "Way Point 3",
      latitude: 38.91040213277608,
      longitude: -77.03848242759705);

  final _stop1 = WayPoint(
    name: "Way Point 2",
    latitude: -13.0127,
    longitude: -38.4742,
  );

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
  @override
  void initState() {
    super.initState();
    getDeviceLocation();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    initialize();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: (Text(
                        "Full Screen Navigation",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  Center(
                    child: AnimatedButton(
                      color: Colors.red,
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 40,
                      onPressed: () async {
                        var wayPoints = List<WayPoint>();
                        final userOrigin = WayPoint(
                          name: "Way Point 3",
                          latitude: _locationData.latitude,
                          longitude: _locationData.longitude,
                        );
                        wayPoints.add(userOrigin);
                        wayPoints.add(_stop1);

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
                        'Iniciar a corrida',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: (Text(
                        "Embedded Navigation",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        child: Text(_routeBuilt && !_isNavigating
                            ? "Clear Route"
                            : "Build Route"),
                        onPressed: _isNavigating
                            ? null
                            : () {
                                if (_routeBuilt) {
                                  _controller.clearRoute();
                                } else {
                                  var wayPoints = List<WayPoint>();
                                  wayPoints.add(_origin);
                                  wayPoints.add(_stop1);
                                }
                              },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        child: Text("Start "),
                        onPressed: _routeBuilt && !_isNavigating
                            ? () {
                                _controller.startNavigation();
                              }
                            : null,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        child: Text("Cancel "),
                        onPressed: _isNavigating
                            ? () {
                                _controller.finishNavigation();
                              }
                            : null,
                      )
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Long-Press Embedded Map to Set Destination",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: (Text(
                        _instruction == null || _instruction.isEmpty
                            ? "Banner Instruction Here"
                            : _instruction,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20, top: 20, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Duration Remaining: "),
                            Text(_durationRemaining != null
                                ? "${(_durationRemaining / 60).toStringAsFixed(0)} minutes"
                                : "---")
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Distance Remaining: "),
                            Text(_distanceRemaining != null
                                ? "${(_distanceRemaining / 1000).toStringAsFixed(1)} Km"
                                : "---")
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider()
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey,
              child: MapBoxNavigationView(
                  options: _options,
                  onRouteEvent: _onEmbeddedRouteEvent,
                  onCreated: (MapBoxNavigationViewController controller) async {
                    _controller = controller;
                    controller.initialize();
                  }),
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
}
