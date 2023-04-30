import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';

import '../../widgets/search_page.dart';

class ServicesScreen extends StatefulWidget {
  static const routeName = '/services';

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String address = '';
  var _isLoading = false;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

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
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });

    await GetAddressFromLatLong(position);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
  }
  // Future<String?> openOthersDialog() => showDialog<String>(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Others'),
  //         content: TextField(
  //           controller: controller,
  //           autofocus: true,
  //           decoration: InputDecoration(
  //             border: OutlineInputBorder(),
  //             hintText: 'Enter other services',
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop(controller.text);
  //               },
  //               child: Text(
  //                 'OK',
  //                 style: TextStyle(color: Theme.of(context).primaryColor),
  //               )),
  //         ],
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        actions: [
          // Navigate to the Search Screen
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              icon: const Icon(Icons.search))
        ],
      ),
      body: Stack(children: [
        GoogleMap(
          myLocationEnabled: true,
          initialCameraPosition: _initialCameraPosition,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: {marker},
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
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Text("Longitude: $long",
                            //     style: TextStyle(fontSize: 20)),
                            // Text("Latitude: $lat",
                            //     style: TextStyle(fontSize: 20)),
                            Center(
                              child: Text(
                                '$address',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Describe Services Needed',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              maxLines: 5,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton(
                                child: Text('Find Worker'),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ]),
    );
  }
}

// bool? Towing = false;
// bool? EngineReplacement = false;
// bool? EngineRepair = false;
// bool? OilChangeOrFilter = false;
// bool? AccidentRecovery = false;
// String otherServices = '';
// late TextEditingController controller;

// SingleChildScrollView(
//   child: Column(
//     children: <Widget>[
//       const SizedBox(
//         height: 40,
//       ),
//       Center(
//         child: Text(
//           'Choose Services you want!',
//           style: TextStyle(
//               color: Theme.of(context).primaryColor,
//               fontSize: 20,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//       const SizedBox(
//         height: 30,
//       ),
//       CheckboxListTile(
//         value: Towing,
//         onChanged: ((val) {
//           setState(() {
//             Towing = val;
//           });
//         }),
//         activeColor: Theme.of(context).primaryColor,
//         title: Text('Towing'),
//       ),
//       CheckboxListTile(
//         value: EngineReplacement,
//         onChanged: ((val) {
//           setState(() {
//             EngineReplacement = val;
//           });
//         }),
//         activeColor: Theme.of(context).primaryColor,
//         title: Text('Engine Replacement'),
//       ),
//       CheckboxListTile(
//         value: EngineRepair,
//         onChanged: ((val) {
//           setState(() {
//             EngineRepair = val;
//           });
//         }),
//         activeColor: Theme.of(context).primaryColor,
//         title: Text('Engine Repair'),
//       ),
//       CheckboxListTile(
//         value: OilChangeOrFilter,
//         onChanged: ((val) {
//           setState(() {
//             OilChangeOrFilter = val;
//           });
//         }),
//         activeColor: Theme.of(context).primaryColor,
//         title: Text('Oil change or Filter'),
//       ),
//       CheckboxListTile(
//         value: AccidentRecovery,
//         onChanged: ((val) {
//           setState(() {
//             AccidentRecovery = val;
//           });
//         }),
//         activeColor: Theme.of(context).primaryColor,
//         title: Text('Accident Recovery'),
//       ),
//       const SizedBox(
//         height: 20,
//       ),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           ElevatedButton(
//             onPressed: () async {
//               final val = await openOthersDialog();
//               if (val == null || val.isEmpty) return;
//               setState(() {
//                 otherServices = val;
//               });
//             },
//             child: Text('Others'),
//             style: ElevatedButton.styleFrom(
//                 fixedSize: Size(100, 40),
//                 backgroundColor: Theme.of(context).primaryColor),
//           ),
//           ElevatedButton(
//             onPressed: () {},
//             child: Text('Done'),
//             style: ElevatedButton.styleFrom(
//                 fixedSize: Size(100, 40),
//                 backgroundColor: Theme.of(context).primaryColor),
//           ),
//         ],
//       ),
//       Text(otherServices),
//     ],
//   ),
// ),
