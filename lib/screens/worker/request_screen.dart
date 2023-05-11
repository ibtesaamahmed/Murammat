import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:murammat_app/providers/worker.dart';
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
  var _accepted = false;
  var _loc = false;
  int? ind;

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

  @override
  initState() {
    _isLoading = true;

    super.initState();
  }

  List<LatLng> polylineCoordinates = [];
  void getPolyPoints(String lat, String long, int index) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCWMxta2y3gpe7EWcsQrR9GXUpjrthC1d0', // Your Google Map Key
      PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
      PointLatLng(double.parse(lat), double.parse(long)),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );

      liveTrack(index);
    }
  }

  Set<Marker> _markers = {};
  _onMapCreated(GoogleMapController controller) async {
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

  deleteNode() async {
    final pro = Provider.of<Worker>(context, listen: false);

    await pro.deleteNode();
    pro.removeListeners();
  }

  StreamSubscription<Position>? locationSubscription;

  void liveTrack(int index) async {
    locationSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      print('locating');
      Provider.of<Worker>(context, listen: false).liveLocationUpdate(
          index,
          currentPosition!.latitude.toString(),
          currentPosition!.longitude.toString());
      setState(() {});
    });
  }

  void cancelLocationUpdates() {
    locationSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Worker>(context, listen: false);
    return Scaffold(
        resizeToAvoidBottomInset: _toggle ? false : true,
        body: WillPopScope(
          onWillPop: () {
            deleteNode();
            cancelLocationUpdates();
            return Future.value(true);
          },
          child: Stack(
            children: [
              GoogleMap(
                  padding: EdgeInsets.only(top: 100),
                  onMapCreated: _onMapCreated,
                  initialCameraPosition:
                      CameraPosition(target: const LatLng(0, 0)),
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  markers: _accepted
                      ? {
                          Marker(
                            markerId: MarkerId('Worker'),
                            infoWindow: InfoWindow(title: 'Worker'),
                            position: LatLng(currentPosition!.latitude,
                                currentPosition!.longitude),
                          ),
                          Marker(
                            markerId: MarkerId('Customer'),
                            infoWindow: InfoWindow(title: 'Customer'),
                            position: LatLng(
                                double.parse(data.requestsList[ind!].lat),
                                double.parse(data.requestsList[ind!].long)),
                          )
                        }
                      : {},
                  polylines: _accepted
                      ? {
                          Polyline(
                              polylineId: PolylineId('Route'),
                              points: polylineCoordinates,
                              color: Theme.of(context).primaryColor,
                              width: 4)
                        }
                      : {}),
              Positioned(
                top: 50,
                right: 15,
                left: 15,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor,
                        blurRadius: 6.0,
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
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor,
                          blurRadius: 6.0,
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
                            ? Consumer<Worker>(
                                builder: (context, provider, _) {
                                  provider.listenToCustomerRequests(
                                      currentPosition!.latitude.toString(),
                                      currentPosition!.longitude.toString());
                                  if (provider.requestsList.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            child: Image.asset(
                                                "assets/images/waiting.png"),
                                            height: 20,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'No Incoming Requests',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return ListView.builder(
                                      itemCount: provider.requestsList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5, bottom: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: ListTile(
                                              style: ListTileStyle.list,
                                              leading: Image.asset(
                                                  'assets/images/logo.png',
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Incoming Request',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  Text(
                                                    provider.requestsList[index]
                                                            .distanceBetween +
                                                        ' km away',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors.grey[900]),
                                                  )
                                                ],
                                              ),
                                              subtitle: Text(provider
                                                      .requestsList[index]
                                                      .services
                                                      .toString()
                                                      .isEmpty
                                                  ? provider.requestsList[index]
                                                      .otherServices
                                                  : provider.requestsList[index]
                                                      .services),
                                              trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    IconButton(
                                                        onPressed: () async {
                                                          await data
                                                              .acceptRequest(
                                                                  index);

                                                          setState(() {
                                                            ind = index;
                                                            _accepted = true;
                                                            _locationSet =
                                                                false;
                                                          });
                                                          getPolyPoints(
                                                              data
                                                                  .requestsList[
                                                                      index]
                                                                  .lat,
                                                              data
                                                                  .requestsList[
                                                                      index]
                                                                  .long,
                                                              index);
                                                          // getCurr();
                                                        },
                                                        icon: Icon(
                                                          Icons.done,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 35,
                                                        )),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.cancel,
                                                          color:
                                                              Theme.of(context)
                                                                  .errorColor,
                                                          size: 35,
                                                        ))
                                                  ]),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              )
                            : !_loc
                                ? Padding(
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
                                                color: Theme.of(context)
                                                    .primaryColor,
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
                                                  await Provider.of<Worker>(
                                                          context,
                                                          listen: false)
                                                      .addWorkerLocation(
                                                          currentPosition!
                                                              .latitude
                                                              .toString(),
                                                          currentPosition!
                                                              .longitude
                                                              .toString());

                                                  setState(() {
                                                    _loc = true;
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
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        Text(
                                          'Connected to Customer',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        TextButton(
                                            onPressed: cancelLocationUpdates,
                                            child: Text('I\'ve Reached '))
                                      ]),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
