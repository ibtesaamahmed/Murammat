import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:murammat_app/providers/customer.dart';

class ServicesScreen extends StatefulWidget {
  static const routeName = '/services';

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<String> services = [];
  var _req = false;
  var _toggle = false;
  var _availale = false;
  final _othersController = TextEditingController();
  String address = '';
  var _isLoading = false;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  String long = "", lat = "";
  bool? towing = false;
  bool? engineReplacement = false;
  bool? engineRepair = false;
  bool? oilChangeOrFilters = false;
  bool? accidentRecovery = false;
  bool? others = false;
  GoogleMapController? mapController;
  Position? currentPosition;
  List<Placemark>? placemarks;
  Placemark? place;

  Set<Marker> _markers = {};

  @override
  void initState() {
    _isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Customer>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: _toggle ? false : true,
      appBar: null,
      body: WillPopScope(
        onWillPop: () {
          deleteAvailableWorker();
          return Future.value(true);
        },
        child: Stack(
          children: [
            Consumer<Customer>(
              builder: (context, value, _) {
                if (_req) {
                  value.listenToLocationUpdate();
                  _markers = {
                    Marker(
                      markerId: MarkerId('Customer'),
                      position: LatLng(currentPosition!.latitude,
                          currentPosition!.longitude),
                    ),
                    Marker(
                      markerId: MarkerId('Worker'),
                      position: LatLng(
                          double.parse(value.lat != null ? value.lat! : '0'),
                          double.parse(value.long != null ? value.long! : '0')),
                    ),
                  };
                }
                return GoogleMap(
                  padding: EdgeInsets.only(top: _req ? 440 : 350),
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  initialCameraPosition:
                      CameraPosition(target: const LatLng(0, 0)),
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  markers: _req ? _markers : {},
                );
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: _req ? 200 : 300.0,
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
                      : _availale
                          ? data.availaleWorkers.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        child: Image.asset(
                                            "assets/images/waiting.png"),
                                        height: 20,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'No available Workers',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      IconButton(
                                          onPressed: _getAvailableWorkers,
                                          icon: Icon(Icons.refresh))
                                    ],
                                  ),
                                )
                              : _req
                                  ? Consumer<Customer>(
                                      builder: (context, value, _) {
                                        return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              value.accepted == false
                                                  ? Center(
                                                      child:
                                                          CustomCircularProgressIndicator(),
                                                    )
                                                  : Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          child: Image.asset(
                                                            'assets/images/mechanic.png',
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                          height: 40,
                                                        ),
                                                        Text(
                                                            'Request Accepted'),
                                                        TextButton(
                                                            onPressed: () {
                                                              data.removeListen();
                                                            },
                                                            child: Text(
                                                                'Worker Reached')),
                                                      ],
                                                    )
                                            ]);
                                      },
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              leading: Image.asset(
                                                  'assets/images/logo.png',
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              title: Text('Available'),
                                              subtitle: Text(data
                                                      .availaleWorkers[index]
                                                      .distanceBetween +
                                                  ' km away'),
                                              trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    IconButton(
                                                        onPressed: () async {
                                                          await data.sendRequest(
                                                              data
                                                                  .availaleWorkers[
                                                                      index]
                                                                  .workerId,
                                                              currentPosition!
                                                                  .latitude
                                                                  .toString(),
                                                              currentPosition!
                                                                  .longitude
                                                                  .toString(),
                                                              services,
                                                              _othersController
                                                                  .text);
                                                          await data
                                                              .listenToAcceptedRequests();
                                                          setState(() {
                                                            _req = true;
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.done,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 35,
                                                        )),
                                                  ]),
                                            );
                                          },
                                          itemCount:
                                              data.availaleWorkers.length,
                                        ))
                                      ],
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
                                                  controller: _othersController,
                                                  maxLines: 3,
                                                  decoration: InputDecoration(
                                                    label: Text('Description'),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 2,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                        onPressed: _getAvailableWorkers,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text('Find Worker'),
                                            Icon(Icons.chevron_right),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  _getAvailableWorkers() async {
    try {
      towing! ? services.add('Towing') : null;
      engineRepair! ? services.add('Engine Repair') : null;
      engineReplacement! ? services.add('Engine Replacement') : null;
      oilChangeOrFilters! ? services.add('Oil change and Filters') : null;
      accidentRecovery! ? services.add('Accident Recovery') : null;
      if (services.isEmpty && _othersController.text.isEmpty) {
        _showErrorDialog('Select any Service');
        return;
      }
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Customer>(context, listen: false).searchWorkers(
          currentPosition!.latitude.toString(),
          currentPosition!.longitude.toString());
      setState(() {
        _isLoading = false;
        _availale = true;
      });
    } catch (error) {
      throw error;
    }
  }

  deleteAvailableWorker() async {
    await Provider.of<Customer>(context, listen: false).deleteAvailableWorker();
  }
}
