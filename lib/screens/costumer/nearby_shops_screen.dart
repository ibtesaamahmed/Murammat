import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:murammat_app/providers/customer.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NearByShopsScreen extends StatefulWidget {
  static const routeName = '/nearby-shops-customers';

  @override
  State<NearByShopsScreen> createState() => _NearByShopsScreenState();
}

class _NearByShopsScreenState extends State<NearByShopsScreen> {
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
        await Provider.of<Customer>(context, listen: false).searchWorkers(
            currentPosition!.latitude.toString(),
            currentPosition!.longitude.toString());
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
  }

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(Duration.zero).then((_) => getPositionAndAddress());
    super.initState();
  }

  // void openGoogleMaps(double latitude, double longitude) async {
  //   final url = Uri.parse(
  //       'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  void openGoogleMaps(double latitude, double longitude) {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Google Maps'),
          ),
          body: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(url)),
          ),
        ),
      ),
    );
  }

  // Future<void> _refresh(BuildContext context)async{
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Customer>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Nearby Shops')),
      body: _isLoading
          ? CustomCircularProgressIndicator()
          : data.availaleWorkers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: Image.asset("assets/images/waiting.png"),
                        height: 50,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No Neary Shops!',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(5)),
                            child: ListTile(
                              leading: Image.asset('assets/images/logo.png',
                                  color: Theme.of(context).primaryColor),
                              title: Text('Available Shop'),
                              subtitle: Text(
                                  data.availaleWorkers[index].distanceBetween +
                                      ' km away'),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                        onPressed: () => openGoogleMaps(
                                            double.parse(data
                                                .availaleWorkers[index]
                                                .workerLat),
                                            double.parse(data
                                                .availaleWorkers[index]
                                                .workerLong)),
                                        icon: Icon(
                                          Icons.directions,
                                          color: Theme.of(context).primaryColor,
                                          size: 35,
                                        )),
                                  ]),
                            ),
                          );
                        },
                        itemCount: data.availaleWorkers.length,
                      ))
                    ],
                  ),
                ),
    );
  }
}
