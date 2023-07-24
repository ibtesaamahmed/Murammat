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
  // var _isLoading = false;
  // var _visibility = false;
  List<Placemark>? placemarks;
  Placemark? place;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? formattedTime;

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    // final provider = Provider.of<Appointments>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Book Appointment')),
        body: FutureBuilder(
          future: getWorkerAndPositionAndAddress(context),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CustomCircularProgressIndicator(),
                )
              : Container(
                  child: RefreshIndicator(
                    onRefresh: () => getWorkerAndPositionAndAddress(context),
                    color: Theme.of(context).primaryColor,
                    child: Consumer<Appointments>(
                      builder: (context, value, child) => value
                              .availableForAppointment.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    child: Image.asset(
                                        "assets/images/waiting.png"),
                                    height: 50,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'No Availability Nearby!',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(
                                          _selectedDate == null
                                              ? 'No Date Choosen'
                                              : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
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
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(
                                          formattedTime == null
                                              ? 'No Time Choosen'
                                              : 'Picked Time: ' +
                                                  formattedTime!,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
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
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  ),
                                  Container(
                                    height: 535,
                                    child: Stack(children: <Widget>[
                                      ListView.builder(
                                        itemCount: value
                                            .availableForAppointment.length,
                                        itemBuilder: (context, index) => Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                          elevation: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  'Address',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                                Text(
                                                  value
                                                      .availableForAppointment[
                                                          index]
                                                      .workerAddress,
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                                Text(
                                                  value
                                                          .availableForAppointment[
                                                              index]
                                                          .distanceBetween +
                                                      ' km away',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                                TextField(
                                                  controller:
                                                      _descriptipnController,
                                                  maxLines: 3,
                                                  decoration: InputDecoration(
                                                    label: Text('Description'),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton.icon(
                                                    onPressed: () {
                                                      _bookAppointment(
                                                          value
                                                              .availableForAppointment[
                                                                  index]
                                                              .distanceBetween,
                                                          value
                                                              .availableForAppointment[
                                                                  index]
                                                              .workerId);
                                                    },
                                                    icon: Icon(
                                                        Icons.app_registration),
                                                    label: Text('Book Now'))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
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
            firstDate: DateTime.now(),
            lastDate: DateTime(2025))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero)
        .then((_) async => await getWorkerAndPositionAndAddress(context));
    super.initState();
  }

  Future<void> getWorkerAndPositionAndAddress(BuildContext ctx) async {
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
        final provider = Provider.of<Appointments>(ctx, listen: false);
        await provider.searchWorkerForAppointment(
            currentPosition != null
                ? currentPosition!.latitude.toString()
                : '0',
            currentPosition != null
                ? currentPosition!.longitude.toString()
                : '0');
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
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
              ],
            ));
  }

  Future<void> _bookAppointment(String distanceBtw, String workerId) async {
    if (formattedTime == null ||
        _selectedDate == null ||
        _descriptipnController.text.isEmpty) {
      _showErrorDialog('Missing Fields.');
      return;
    }
    await Provider.of<Appointments>(context, listen: false).bookAppointment(
        'Pending',
        distanceBtw,
        address,
        workerId,
        _selectedDate!,
        formattedTime!,
        _descriptipnController.text);
    Navigator.of(context).pop();
  }
}
