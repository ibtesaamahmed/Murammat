import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:murammat_app/providers/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appointment {
  String serviceDescription;
  DateTime dateTime;
  Appointment({required this.serviceDescription, required this.dateTime});
}

class Appointments with ChangeNotifier {
  final userId;
  Appointments(this.userId);

  List<Appointment> _appointments = [];
  List<Appointment> get appointment => _appointments;

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

  var data;
  Future<void> checkIt() async {
    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
    final response = await _databaseReference
        .child('appointmentsAvailability')
        .child(userId)
        .get();
    Map<dynamic, dynamic> extractedData =
        response.value as Map<dynamic, dynamic>;
    data = extractedData;
  }

  Future<void> searchWorkerForAppointment() async {
    DatabaseReference _databaseReferences = FirebaseDatabase.instance.ref();
    final response =
        await _databaseReferences.child('appointmentsAvailability').get();
    Map<dynamic, dynamic> extractedData =
        response.value as Map<dynamic, dynamic>;
    extractedData.forEach((key, value) {});
  }
}
