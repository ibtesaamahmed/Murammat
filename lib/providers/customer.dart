import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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
      if (distanceBtw <= 5000) {
        _availableWorkers.add(AvailableWorkers(
            workerId: workerId,
            workerLat: value['lat'],
            workerLong: value['long'],
            distanceBetween: distanceBtw.toStringAsFixed(1)));
      }
    });
    notifyListeners();

    // final url = Uri.parse(
    //     'https://murammat-b174c-default-rtdb.firebaseio.com/workersShopLocation.json?auth=$authToken');
    // final response = await http.get(url);
    // final extractedData = json.decode(response.body) as Map<String, dynamic>;
    // final List<AvailableWorkers> workers = [];
    // extractedData.forEach((_, value) async {
    //   double distanceBtw = await Geolocator.distanceBetween(
    //       double.parse(myLat),
    //       double.parse(myLong),
    //       double.parse(value['lat']),
    //       double.parse(value['long']));
    //   if (distanceBtw <= 5000) {
    //     workers.add(AvailableWorkers(
    //         workerId: value['workerId'],
    //         workerLat: value['lat'],
    //         workerLong: value['long'],
    //         distanceBetween: (distanceBtw / 1000).toStringAsFixed(1)));
    //   }
    // });
    // _availableWorkers = workers;
    // notifyListeners();
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
    // final url = Uri.parse(
    //     'https://murammat-b174c-default-rtdb.firebaseio.com/requestsFromCustomer.json');
    // await http.post(url,
    //     body: json.encode({
    //       'customerId': userId,
    //       'workerId': workerId,
    //       'lat': lat,
    //       'long': long,
    //     }));
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
}
