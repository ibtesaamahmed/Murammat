import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:murammat_app/providers/worker_location.dart';
import 'package:murammat_app/screens/worker/new_screen.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  var _toggle = false;
  var _locationSet = false;

  GoogleMapController? mapController;
  Position? currentPosition;
  // Set<Circle> circles = {};
  List<Placemark>? placemarks;
  Placemark? place;
  String address = '';
  var _isLoading = false;
  bool servicestatus = false;
  late LocationPermission permission;
  bool haspermission = false;

  Set<Marker> _markers = {};
  _onMapCreated(GoogleMapController controller) async {
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
        mapController = controller;
        currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        mapController!.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(currentPosition!.latitude, currentPosition!.longitude), 15));

        placemarks = await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude);
        print(placemarks);
        place = placemarks![0];
        address =
            '${place!.street}, ${place!.subLocality}, ${place!.locality}, ${place!.country}';
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
  }

  void _addMarker(LatLng position) async {
    setState(() {
      _isLoading = true;
    });
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    place = placemarks![0];
    address =
        '${place!.street}, ${place!.subLocality}, ${place!.locality}, ${place!.country}';
    setState(() {
      // Remove existing markers
      _markers.clear();

      // Add a new marker at the specified position
      _markers.add(
        Marker(
          markerId: MarkerId("new_location"),
          position: position,
          infoWindow: InfoWindow(title: "New Location"),
        ),
      );

      // Update the current position to the coordinates of the new marker
      currentPosition = Position(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
      );
      print(position.latitude);
      print(position.longitude);
      _isLoading = false;
    });
  }

  deleteNode() async {
    await Provider.of<WorkerShopLocation>(context, listen: false).deleteNode();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: _toggle ? false : true,
        body: WillPopScope(
          onWillPop: () => deleteNode(),
          child: Stack(
            children: [
              GoogleMap(
                padding: EdgeInsets.only(top: 115),
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: const LatLng(0, 0)),
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                markers: _markers,
                onTap: (LatLng position) {
                  _addMarker(position);
                },
              ),
              Positioned(
                top: 70,
                right: 15,
                left: 15,
                child: Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(30),
                    // borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(30),
                    //     topRight: Radius.circular(30)),
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
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 15),
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
                  Container(
                    height: _locationSet ? 300.0 : 200.0,
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
                        : _locationSet
                            ? Text('samiii')
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Center(
                                      child: Text(
                                        address,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    Center(
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              await Provider.of<
                                                          WorkerShopLocation>(
                                                      context,
                                                      listen: false)
                                                  .addWorkerLocation(
                                                      currentPosition!.latitude
                                                          .toString(),
                                                      currentPosition!.longitude
                                                          .toString());
                                              setState(() {
                                                _isLoading = false;
                                                _locationSet = true;
                                              });
                                            } catch (error) {
                                              throw error;
                                            }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(Icons.done),
                                              const SizedBox(width: 8),
                                              Text('Go Online'),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
