import 'package:flutter/material.dart';
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
    final pro = Provider.of<Worker>(context, listen: false);

    await pro.deleteNode();
    pro.removeListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: _toggle ? false : true,
        body: WillPopScope(
          onWillPop: () {
            deleteNode();
            return Future.value(true);
          },
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
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: ListView.builder(
                                        itemCount: provider.requestsList.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            style: ListTileStyle.list,
                                            leading: Text(provider
                                                    .requestsList[index]
                                                    .distanceBetween +
                                                ' km'),
                                            // leading: Image.asset(
                                            //     'assets/images/logo.png',
                                            //     color: Theme.of(context)
                                            //         .primaryColor),
                                            title: Text('Incoming Request'),
                                            subtitle: Text(provider
                                                .requestsList[index].services
                                                .toString()),
                                            trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.done,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 35,
                                                      )),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: Theme.of(context)
                                                            .errorColor,
                                                        size: 35,
                                                      ))
                                                ]),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                              )
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
                                              await Provider.of<Worker>(context,
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
