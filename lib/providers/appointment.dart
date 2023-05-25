import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// class Appointment {
//   String serviceDescription;
//   DateTime date;
//   String time;
//   String status;
//   Appointment(
//       {required this.serviceDescription,
//       required this.date,
//       required this.time,
//       required this.status});
// }

class AcceptedAppointments {
  String appointmentId;
  String serviceDescription;
  DateTime date;
  String time;
  String status;
  String distanceBetween;
  AcceptedAppointments(
      {required this.appointmentId,
      required this.serviceDescription,
      required this.date,
      required this.time,
      required this.status,
      required this.distanceBetween});
}

class RejectedAppointments {
  String appointmentId;
  String serviceDescription;
  DateTime date;
  String time;
  String status;
  String distanceBetween;
  RejectedAppointments(
      {required this.appointmentId,
      required this.serviceDescription,
      required this.date,
      required this.time,
      required this.status,
      required this.distanceBetween});
}

class PendingAppointments {
  String appointmentId;
  String serviceDescription;
  DateTime date;
  String time;
  String status;
  String distanceBetween;
  PendingAppointments(
      {required this.appointmentId,
      required this.serviceDescription,
      required this.date,
      required this.time,
      required this.status,
      required this.distanceBetween});
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

  // Appointments Getter
  // List<Appointment> _appointments = [];
  // List<Appointment> get appointment => _appointments;
  // Available for Appointment Getter
  List<AvailableForAppointment> _availableForAppointment = [];
  List<AvailableForAppointment> get availableForAppointment =>
      _availableForAppointment;
  // Accepted Appointment Getter
  List<AcceptedAppointments> _acceptedAppointments = [];
  List<AcceptedAppointments> get acceptedAppointments => _acceptedAppointments;
  // Rejected Appointment Getter
  List<RejectedAppointments> _rejectedAppointments = [];
  List<RejectedAppointments> get rejectedAppointments => _rejectedAppointments;
  // Pending Appointment Getter
  List<PendingAppointments> _pendingAppointments = [];
  List<PendingAppointments> get pendingAppointments => _pendingAppointments;

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

  Future<void> bookAppointment(
      String status,
      String distanceBetween,
      String customerAddress,
      String workerId,
      DateTime date,
      String time,
      String description) async {
    DatabaseReference _dbReference = FirebaseDatabase.instance.ref();
    _dbReference.child('appointments')
      ..push().set({
        'workerId': workerId,
        'customerId': userId,
        'status': status,
        'customerAddress': customerAddress,
        'date': date.toIso8601String(),
        'time': time,
        'distanceBetween': distanceBetween,
        'description': description,
      });
  }

  Future<void> getAppointments(String which) async {
    DatabaseReference _dbref = FirebaseDatabase.instance.ref();
    final response = await _dbref.child('appointments').get();
    Map<dynamic, dynamic> extractedData = response.value == null
        ? Map()
        : response.value as Map<dynamic, dynamic>;

    final List<AcceptedAppointments> accepted = [];
    final List<PendingAppointments> pending = [];
    final List<RejectedAppointments> rejected = [];
    extractedData.forEach((key, value) {
      if (value[which == 'customer' ? 'customerId' : 'workerId'] == userId &&
          value['status'] == 'Pending') {
        pending.add(PendingAppointments(
          appointmentId: key,
          serviceDescription: value['description'],
          date: DateTime.tryParse(value['date'])!,
          time: value['time'],
          status: value['status'],
          distanceBetween: value['distanceBetween'],
        ));
      } else if (value[which == 'customer' ? 'customerId' : 'workerId'] ==
              userId &&
          value['status'] == 'Accepted') {
        accepted.add(AcceptedAppointments(
            appointmentId: key,
            serviceDescription: value['description'],
            date: DateTime.tryParse(value['date'])!,
            time: value['time'],
            status: value['status'],
            distanceBetween: value['distanceBetween']));
      } else if (value[which == 'customer' ? 'customerId' : 'workerId'] ==
              userId &&
          value['status'] == 'Rejected') {
        rejected.add(RejectedAppointments(
            appointmentId: key,
            serviceDescription: value['description'],
            date: DateTime.tryParse(value['date'])!,
            time: value['time'],
            status: value['status'],
            distanceBetween: value['distanceBetween']));
      }
    });
    _acceptedAppointments = accepted;
    _pendingAppointments = pending;
    _rejectedAppointments = rejected;
    notifyListeners();
  }

  Future<void> cancelAppointmentCustomer(
      String appointmentId, String which) async {
    Map<String, dynamic> updatedValues = {
      'status': 'Rejected',
    };
    DatabaseReference _dbref = FirebaseDatabase.instance.ref();
    await _dbref
        .child('appointments')
        .child(appointmentId)
        .update(updatedValues);
    await getAppointments(which == 'customer' ? 'customer' : 'worker');
    notifyListeners();
  }

  Future<void> acceptAppointmentWorker(String appointmentId) async {
    Map<String, dynamic> updatedValues = {
      'status': 'Accepted',
    };
    DatabaseReference _dbref = FirebaseDatabase.instance.ref();
    await _dbref
        .child('appointments')
        .child(appointmentId)
        .update(updatedValues);
    await getAppointments('worker');
    notifyListeners();
  }
}
