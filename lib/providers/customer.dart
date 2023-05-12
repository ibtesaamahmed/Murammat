import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AvailableWorkers {
  String workerId;
  String workerLat;
  String workerLong;
  String distanceBetween;
  AvailableWorkers({
    required this.workerId,
    required this.workerLat,
    required this.workerLong,
    required this.distanceBetween,
  });
}

class Customer with ChangeNotifier {
  final authToken;
  final userId;
  Customer(this.authToken, this.userId);

  List<AvailableWorkers> _availableWorkers = [];
  List<AvailableWorkers> get availaleWorkers {
    return [..._availableWorkers];
  }

  Future<void> searchWorkers(String myLat, String myLong) async {
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref().child('availableWorkerShop');
    final response = await _databaseReference.get();
    Map<dynamic, dynamic> extractedData =
        response.value as Map<dynamic, dynamic>;
    extractedData.forEach((workerId, value) async {
      double distanceBtw = await Geolocator.distanceBetween(
          double.parse(myLat),
          double.parse(myLong),
          double.parse(value['lat']),
          double.parse(value['long']));
      distanceBtw = distanceBtw / 1000;
      if (distanceBtw <= 5) {
        _availableWorkers.add(AvailableWorkers(
            workerId: workerId,
            workerLat: value['lat'],
            workerLong: value['long'],
            distanceBetween: distanceBtw.toStringAsFixed(1)));
      }
    });
    notifyListeners();
  }

  Future<void> sendRequest(String workerId, String lat, String long,
      List<String> services, String others) async {
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref().child('requestsFromCustomer');
    await _databaseReference
      ..push().set({
        'workerId': workerId,
        'customerId': userId,
        'lat': lat,
        'long': long,
        'services': services.toString(),
        'otherServices': others,
      });
  }

  Future<void> deleteAvailableWorker() async {
    var id;
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref().child('requestsFromCustomer');
    final response = await _databaseReference.get();
    Map<dynamic, dynamic> extractedData =
        response.value as Map<dynamic, dynamic>;
    extractedData.forEach((key, value) {
      if (value['customerId'] == userId) {
        id = key;
      }
    });
    await _databaseReference.child(id).remove();
    _availableWorkers.clear();
    notifyListeners();
  }

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  StreamSubscription<DatabaseEvent>? _subscription;
  bool? accepted = false;

  Future<void> listenToAcceptedRequests() async {
    _subscription = _dbRef
        .child('acceptedRequests')
        .orderByChild('customerId')
        .equalTo(userId)
        .onValue
        .listen((event) {
      print('listening');
      if (event.snapshot.value != null) {
        print('yes');
        accepted = true;
        notifyListeners();
        removeListen();
      }
    });
  }

  String? lat;
  String? long;

  Future<void> listenToLocationUpdate() async {
    _subscription = _dbRef
        .child('liveTracking')
        .child(userId)
        .onValue
        .listen((DatabaseEvent event) {
      print('listen loc');
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> extractedData =
            event.snapshot.value as Map<dynamic, dynamic>;
        lat = extractedData['lat'];
        long = extractedData['long'];
        print(lat);
        print(long);
        notifyListeners();
      }
    });
  }

  void removeListen() {
    _subscription?.cancel();
    _subscription = null;
    print('listener removed');
  }
}
