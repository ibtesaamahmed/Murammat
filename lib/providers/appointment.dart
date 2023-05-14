import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:murammat_app/providers/auth.dart';

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

  Future<void> setAppointmentAvailability() async {
    DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
    _databaseReference.child('appointmentsAvailability').child(userId).set({
      'availanle': true,
    });
  }

  Future<void> removeAppointmentAvailability() async {}
}
