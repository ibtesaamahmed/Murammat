import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:murammat_app/providers/customer.dart';
import 'package:provider/provider.dart';

class NearByShopsScreen extends StatelessWidget {
  static const routeName = '/nearby-shops-customers';

  Position? currentPosition;
  String address = '';
  bool servicestatus = false;
  late LocationPermission permission;
  bool haspermission = false;
  var _isLoading = false;
  var _visibility = false;
  List<Placemark>? placemarks;
  Placemark? place;
  getPositionAndAddress() async {
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
        currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        placemarks = await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude);
        print(placemarks);
        place = placemarks![0];
        address =
            '${place!.street}, ${place!.subLocality}, ${place!.locality}, ${place!.country}';
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
  }
  // Future<void> _refresh(BuildContext context)async{
  //   await Provider.of<Customer>(context,listen: false).searchWorkers(myLat, myLong)
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Shops')),
    );
  }
}
