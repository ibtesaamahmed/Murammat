import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class History {
  String description;
  String price;
  String distanceBetween;
  DateTime dateTime;
  History(
      {required this.description,
      required this.price,
      required this.distanceBetween,
      required this.dateTime});
}

class MyHistory with ChangeNotifier {
  final userId;
  MyHistory(this.userId);
  List<History> _customerHistory = [];
  List<History> _workerHistory = [];
  List<History> get workerHistory => _workerHistory;
  List<History> get customerHistory => _customerHistory;

  Future<void> getCustomerHistory() async {
    List<History> loaded = [];
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref().child('history');
    final response = await _databaseReference.get();
    Map<dynamic, dynamic> extractedData = response.value == null
        ? Map()
        : response.value as Map<dynamic, dynamic>;
    extractedData.forEach((key, value) {
      if (value['customerId'] == userId) {
        loaded.add(History(
          description: value['description'],
          price: value['price'],
          distanceBetween: value['distance'],
          dateTime: DateTime.tryParse(value['dateTime'])!,
        ));
      }
    });
    _customerHistory = loaded;
    notifyListeners();
  }

  Future<void> getWorkerHistory() async {
    List<History> loaded = [];
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref().child('history');
    final response = await _databaseReference.get();
    Map<dynamic, dynamic> extractedData =
        response.value as Map<dynamic, dynamic>;
    extractedData.forEach((key, value) {
      if (value['workerId'] == userId) {
        loaded.add(History(
          description: value['description'],
          price: value['price'],
          distanceBetween: value['distance'],
          dateTime: DateTime.tryParse(value['dateTime'])!,
        ));
      }
    });
    _workerHistory = loaded;
    notifyListeners();
  }
}
