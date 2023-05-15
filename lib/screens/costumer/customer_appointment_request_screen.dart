import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:murammat_app/providers/appointment.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class CustomerAppointmentRequestScreen extends StatefulWidget {
  const CustomerAppointmentRequestScreen({super.key});

  @override
  State<CustomerAppointmentRequestScreen> createState() =>
      _CustomerAppointmentRequestScreenState();
}

class _CustomerAppointmentRequestScreenState
    extends State<CustomerAppointmentRequestScreen> {
  final _descriptipnController = TextEditingController();
  Position? currentPosition;
  String address = '';
  bool servicestatus = false;
  late LocationPermission permission;
  bool haspermission = false;
  var _isLoading = false;
  var _visibility = false;
  List<Placemark>? placemarks;
  Placemark? place;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? formattedTime;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Appointments>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Book Appointment')),
        body: !_visibility
            ? _isLoading
                ? CustomCircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: ElevatedButton(
                            child: Text('Show Available Shops'),
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await getPositionAndAddress();
                              await provider.searchWorkerForAppointment(
                                  currentPosition!.latitude.toString(),
                                  currentPosition!.longitude.toString());
                              setState(() {
                                _isLoading = false;
                                _visibility = true;
                              });
                            }),
                      ),
                    ],
                  )
            : provider.availableForAppointment.isEmpty
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
                          'No Vehicles Added Yet!',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              _selectedDate == null
                                  ? 'No Date Choosen'
                                  : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: _showDatePicker,
                              child: Text(
                                _selectedDate == null
                                    ? 'Choose Date'
                                    : 'Change Date',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              formattedTime == null
                                  ? 'No Time Choosen'
                                  : 'Picked Time: ' + formattedTime!,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: _showTimePicker,
                              child: Text(
                                formattedTime == null
                                    ? 'Choose Time'
                                    : 'Change Time',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: 535,
                          child: ListView.builder(
                            itemCount: provider.availableForAppointment.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 3,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Text(
                                    provider.availableForAppointment[index]
                                        .workerAddress,
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  Text(
                                    provider.availableForAppointment[index]
                                            .distanceBetween +
                                        ' km away',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  TextField(
                                    controller: _descriptipnController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      label: Text('Description'),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                      onPressed: _bookAppointment,
                                      icon: Icon(Icons.app_registration),
                                      label: Text('Book Now'))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ));
  }

  void _showTimePicker() async {
    _selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (_selectedTime != null) {
      final timeFormat = DateFormat('h:mm a');
      formattedTime = timeFormat.format(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ));
      setState(() {});
    }
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

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

  _bookAppointment() async {
    if (formattedTime == null || _selectedDate == null) {
      _showErrorDialog('Choose date and time.');
    }
  }
}
