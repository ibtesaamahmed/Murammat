import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ServicesScreen extends StatefulWidget {
  static const routeName = '/services';

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  void initState() {
    checkGps();
    super.initState();
  }

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  final _initialCameraPosition = CameraPosition(
    target: LatLng(
        double.parse('33.69689874685456'), double.parse('72.98450682424959')),
    zoom: 15,
  );

  checkGps() async {
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
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

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
        title: Text("Services"),
        centerTitle: true,
      ),
      body: Stack(children: [
        GoogleMap(
          myLocationEnabled: true,
          initialCameraPosition: _initialCameraPosition,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: {},
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor,
                    blurRadius: 15.0,
                    spreadRadius: 5.0,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                  )
                ],
              ),
              child: Column(
                children: <Widget>[
                  servicestatus ? Text("GPS enabled") : Text("GPS disabled"),
                  haspermission ? Text("GPS enabled") : Text("GPS disabled"),
                  Text("Longitude: $long", style: TextStyle(fontSize: 20)),
                  Text(
                    "Latitude: $lat",
                    style: TextStyle(fontSize: 20),
                  )
                ],
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
