import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class AvailableWorkers {
  String id;
  String lat;
  String long;
  String distanceBetween;
  AvailableWorkers({
    required this.id,
    required this.lat,
    required this.long,
    required this.distanceBetween,
  });
}

class SearchWorker with ChangeNotifier {
  final authToken;
  final userId;
  SearchWorker(this.authToken, this.userId);

  List<AvailableWorkers> _availableWorkers = [];
  List<AvailableWorkers> get availaleWorkers {
    return [..._availableWorkers];
  }

  Future<void> searchWorkers(String myLat, String myLong) async {
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/workersShopLocation.json?auth=$authToken');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<AvailableWorkers> workers = [];
    extractedData.forEach((_, value) async {
      double distanceBtw = await Geolocator.distanceBetween(
          double.parse(myLat),
          double.parse(myLong),
          double.parse(value['lat']),
          double.parse(value['long']));
      if (distanceBtw <= 5000) {
        workers.add(AvailableWorkers(
            id: value['workerId'],
            lat: value['lat'],
            long: value['long'],
            distanceBetween: (distanceBtw / 1000).toStringAsFixed(1)));
      }
    });
    _availableWorkers = workers;
    notifyListeners();
  }

  Future<void> sendRequest(String workerId, String lat, String long) async {
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/requestsFromCustomer.json');
    await http.post(url,
        body: json.encode({
          'customerId': userId,
          'workerId': workerId,
          'lat': lat,
          'long': long,
        }));
  }
}
