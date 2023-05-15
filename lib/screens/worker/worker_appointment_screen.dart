import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:murammat_app/providers/appointment.dart';
import 'package:murammat_app/screens/worker/worker_appointment_request_screen.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkerAppointmentScreen extends StatefulWidget {
  const WorkerAppointmentScreen({super.key});

  @override
  State<WorkerAppointmentScreen> createState() =>
      _WorkerAppointmentScreenState();
}

class _WorkerAppointmentScreenState extends State<WorkerAppointmentScreen> {
  Position? currentPosition;
  String address = '';
  bool servicestatus = false;
  late LocationPermission permission;
  bool haspermission = false;
  var _isLoading = false;
  var _available = false;
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

  Future<void> _checkAvailable() async {
    final provider = Provider.of<Appointments>(context, listen: false);
    final check = await provider.checkIt();
    print(check);
    if (!check) {
      setState(() {
        _available = false;
        _isLoading = false;
      });
    } else {
      setState(() {
        _available = true;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(Duration.zero).then((_) => _checkAvailable());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Appointments'),
          actions: [
            _available
                ? IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WorkerAppointmentRequestsScreen(),
                      ));
                    },
                    icon: Icon(Icons.person_add))
                : Container(),
          ],
        ),
        body: _isLoading
            ? CustomCircularProgressIndicator()
            : !_available
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await getPositionAndAddress();
                            await Provider.of<Appointments>(context,
                                    listen: false)
                                .setAppointmentAvailability(
                                    currentPosition!.latitude.toString(),
                                    currentPosition!.longitude.toString(),
                                    address);
                            await _checkAvailable();
                          },
                          child: Text('Get Started'),
                        ),
                      )
                    ],
                  )
                : Container());
  }
}
