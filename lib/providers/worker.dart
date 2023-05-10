import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Requests {
  String customerId;
  String lat;
  String long;
  String services;
  String otherServices;
  String distanceBetween;

  Requests(
      {required this.customerId,
      required this.lat,
      required this.long,
      required this.services,
      required this.otherServices,
      required this.distanceBetween});
}

class Worker with ChangeNotifier {
  final authToken;
  final userId;
  String? id;
  Worker(
    this.authToken,
    this.userId,
  );

  List<Requests> _requestsList = [];
  List<Requests> get requestsList => _requestsList;

  Future<void> addWorkerLocation(String? lat, String? long) async {
    final DatabaseReference _databaseReference = FirebaseDatabase.instance
        .ref()
        .child('availableWorkerShop')
        .child(userId);
    await _databaseReference.set({
      'lat': lat,
      'long': long,
    });
  }

  Future<void> deleteNode() async {
    final DatabaseReference _databaseReference = FirebaseDatabase.instance
        .ref()
        .child('availableWorkerShop')
        .child(userId);
    await _databaseReference.remove();
  }

  final DatabaseReference _databaseReferences =
      FirebaseDatabase.instance.ref().child('requestsFromCustomer');
  StreamSubscription<DatabaseEvent>? _subscription;

  Future<void> listenToCustomerRequests(String myLat, String myLong) async {
    _subscription = _databaseReferences
        .orderByChild('workerId')
        .equalTo(userId)
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> extractedData =
            event.snapshot.value as Map<dynamic, dynamic>;
        print("Listening");
        _requestsList.clear();
        extractedData.forEach((key, value) async {
          double distanceBtw = await Geolocator.distanceBetween(
              double.parse(myLat),
              double.parse(myLong),
              double.parse(value['lat']),
              double.parse(value['long']));
          distanceBtw = distanceBtw / 1000;
          _requestsList.add(Requests(
            customerId: value['customerId'],
            lat: value['lat'],
            long: value['long'],
            services: value['services'],
            otherServices: value['otherServices'],
            distanceBetween: distanceBtw.toStringAsFixed(1),
          ));
        });
        notifyListeners();
      }
    });
  }

  void removeListeners() {
    _subscription?.cancel();
    print('cancelled subscription');
  }

  Future<void> acceptRequest(int index) async {
    DatabaseReference _databaseRef =
        FirebaseDatabase.instance.ref().child('acceptedRequests');
    final customerId = _requestsList[index].customerId;
    await _databaseRef
      ..push().set({
        'customerId': customerId,
        'workerId': userId,
      });
    removeListeners();
  }
}
