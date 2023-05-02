import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';

class ServicesScreen extends StatefulWidget {
  static const routeName = '/services';

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  var _toggle = false;
  String address = '';
  var _isLoading = false;
  var _loading = false;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;
  bool? towing = false;
  bool? engineReplacement = false;
  bool? engineRepair = false;
  bool? oilChangeOrFilters = false;
  bool? accidentRecovery = false;
  bool? others = false;

  late TextEditingController controller;

  final _initialCameraPosition = CameraPosition(
    target: LatLng(
        double.parse('33.63151504740167'), double.parse('73.08072607369083')),
    zoom: 15,
  );

  final Marker marker = Marker(
      markerId: MarkerId('1'),
      position: LatLng(double.parse('33.63151504740167'),
          double.parse('73.08072607369083')));

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                'An Error Occured',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: Text(
                message,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
              ],
            ));
  }

  checkGps() async {
    setState(() {
      _isLoading = true;
    });
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        // setState(() {
        //   _isLoading = false;
        // });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    // setState(() {
    //   //refresh the UI
    // });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude);
      print(position.latitude);

      long = position.longitude.toString();
      lat = position.latitude.toString();
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print('$placemarks yoo');
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: _toggle ? false : true,
      appBar: null,
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            initialCameraPosition: _initialCameraPosition,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: {marker},
          ),
          Positioned(
            top: 70,
            right: 15,
            left: 15,
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      onTap: () {
                        _toggle = true;
                      },
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Search..."),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20, bottom: 20),
                child: IconButton(
                    onPressed: checkGps,
                    icon: Icon(
                      Icons.my_location,
                      color: Theme.of(context).primaryColor,
                      size: 40,
                    )),
              ),
              Container(
                height: 300.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(30),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  // color: Theme.of(context).canvasColor,
                  color: Colors.white,

                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor,
                      blurRadius: 6.0,
                      // spreadRadius: 2.0,
                      offset: Offset(
                        0.0,
                        1.0,
                      ),
                    ),
                  ],
                ),
                child: _isLoading
                    ? Center(
                        child: CustomCircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: Text(
                                address,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                'Choose Services you want!',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    CheckboxListTile(
                                      value: towing,
                                      onChanged: ((val) {
                                        setState(() {
                                          towing = val;
                                        });
                                      }),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      title: Text('Towing'),
                                    ),
                                    CheckboxListTile(
                                      value: engineReplacement,
                                      onChanged: ((val) {
                                        setState(() {
                                          engineReplacement = val;
                                        });
                                      }),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      title: Text('Engine Replacement'),
                                    ),
                                    CheckboxListTile(
                                      value: engineRepair,
                                      onChanged: ((val) {
                                        setState(() {
                                          engineRepair = val;
                                        });
                                      }),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      title: Text('Engine Repair'),
                                    ),
                                    CheckboxListTile(
                                      value: oilChangeOrFilters,
                                      onChanged: ((val) {
                                        setState(() {
                                          oilChangeOrFilters = val;
                                        });
                                      }),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      title: Text('Oil change or Filter'),
                                    ),
                                    CheckboxListTile(
                                      value: accidentRecovery,
                                      onChanged: ((val) {
                                        setState(() {
                                          accidentRecovery = val;
                                        });
                                      }),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      title: Text('Accident Recovery'),
                                    ),
                                    CheckboxListTile(
                                      value: others,
                                      onChanged: ((val) {
                                        setState(() {
                                          others = val;
                                        });
                                      }),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      title: Text('Others'),
                                    ),
                                    others!
                                        ? TextField(
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              label: Text('Description'),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 2,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _loading = true;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text('Find Worker'),
                                            Icon(Icons.chevron_right),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          if (_loading)
            Container(
              color: Colors.white30,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      color: Theme.of(context).primaryColor,
                      fit: BoxFit.cover,
                      height: 30,
                      width: 30,
                    ),
                    // you can replace
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                      strokeWidth: 2,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _loading = false;
                          });
                        },
                        child: Text('Press'))
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
