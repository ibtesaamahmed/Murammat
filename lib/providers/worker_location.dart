import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Requests {
  String customerId;
  String lat;
  String long;
  Requests({
    required this.customerId,
    required this.lat,
    required this.long,
  });
}

class WorkerShopLocation with ChangeNotifier {
  String? id;
  String? _lat;
  String? _long;
  final authToken;
  final userId;
  WorkerShopLocation(
    this.authToken,
    this.userId,
    this._lat,
    this._long,
  );

  String? get lat {
    return _lat;
  }

  String? get long {
    return _long;
  }

  List<Requests> _requestsList = [];
  List<Requests> get requestsList => _requestsList;

  Future<void> addWorkerLocation(String? lat, String? long) async {
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/workersShopLocation.json?auth=$authToken');
    final response = await http.post(url,
        body: json.encode({
          'workerId': userId,
          'lat': lat,
          'long': long,
        }));
    id = json.decode(response.body)['name'];
  }

  Future<void> deleteNode() async {
    print('yoooo');
    print(id);
    if (id != null) {
      final url = Uri.parse(
          'https://murammat-b174c-default-rtdb.firebaseio.com/workersShopLocation/$id.json?auth=$authToken');
      await http.delete(url);
    }
  }

  Future<void> listenToCustomerRequest() async {
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref().child('requestsFromCustomer');
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> extractedData =
            event.snapshot.value as Map<dynamic, dynamic>;
        _requestsList.clear();
        extractedData.forEach((key, value) {
          _requestsList.add(Requests(
              customerId: value['customerId'],
              lat: value['lat'],
              long: value['long']));
        });
        notifyListeners();
      }
    });
  }
}

class MyData {
  final String key;
  final String value;

  MyData({required this.key, required this.value});
}

class MyDataProvider extends ChangeNotifier {
  List<MyData> _myDataList = [];

  List<MyData> get myDataList => _myDataList;
  MyDataProvider() {
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref().child('requestsFromCustomer');
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        _myDataList.clear();
        values.forEach((key, value) {
          _myDataList.add(MyData(key: key, value: value));
        });
        notifyListeners();
      }
    });
  }
}
