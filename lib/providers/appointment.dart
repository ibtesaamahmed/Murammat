import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class Appointment {
  String serviceDescription;
  DateTime dateTime;
  Appointment({required this.serviceDescription, required this.dateTime});
}

class AvailableForAppointment {
  String workerId;
  String workerAddress;
  String workerLat;
  String workerLong;
  String distanceBetween;
  AvailableForAppointment({
    required this.workerId,
    required this.workerAddress,
    required this.workerLat,
    required this.workerLong,
    required this.distanceBetween,
  });
}

class Appointments with ChangeNotifier {
  final userId;
  Appointments(this.userId);

  List<Appointment> _appointments = [];
  List<Appointment> get appointment => _appointments;
  List<AvailableForAppointment> _availableForAppointment = [];
  List<AvailableForAppointment> get availableForAppointment =>
      _availableForAppointment;
  Future<void> setAppointmentAvailability(
    String workerLat,
    String workerLong,
    String workerAddress,
  ) async {
    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
    await _databaseReference
        .child('appointmentsAvailability')
        .child(userId)
        .set({
      'workerLat': workerLat,
      'workerLong': workerLong,
      'workerAddress': workerAddress,
    });
  }

  Future<bool> checkIt() async {
    var data;

    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
    final response = await _databaseReference
        .child('appointmentsAvailability')
        .child(userId)
        .get();
    Map<dynamic, dynamic> extractedData = response.value == null
        ? Map()
        : response.value as Map<dynamic, dynamic>;
    data = extractedData.isEmpty ? false : true;
    return data;
  }

  Future<void> searchWorkerForAppointment(String myLat, String myLong) async {
    DatabaseReference _databaseReferences = FirebaseDatabase.instance.ref();
    final response =
        await _databaseReferences.child('appointmentsAvailability').get();
    Map<dynamic, dynamic> extractedData = response.value == null
        ? Map()
        : response.value as Map<dynamic, dynamic>;

    double distanceBtw;
    final List<AvailableForAppointment> _available = [];

    extractedData.forEach((key, value) {
      distanceBtw = Geolocator.distanceBetween(
        double.parse(myLat),
        double.parse(myLong),
        double.parse(value['workerLat']),
        double.parse(value['workerLong']),
      );
      distanceBtw = distanceBtw / 1000;
      if (distanceBtw <= 10) {
        _available.add(AvailableForAppointment(
            workerId: key,
            workerAddress: value['workerAddress'],
            workerLat: value['workerLat'],
            workerLong: value['workerLong'],
            distanceBetween: distanceBtw.toStringAsFixed(1)));
      }
    });
    _availableForAppointment = _available;
    print(_availableForAppointment.iterator.toString());
    notifyListeners();
  }
}
