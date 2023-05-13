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
    _customerHistory.clear();
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref().child('history');
    final response = await _databaseReference.get();
    Map<dynamic, dynamic> extractedData =
        response.value as Map<dynamic, dynamic>;
    extractedData.forEach((key, value) {
      if (value['customerId'] == userId) {
        _customerHistory.add(History(
          description: value['description'],
          price: value['price'],
          distanceBetween: value['distance'],
          dateTime: DateTime.tryParse(value['dateTime'])!,
        ));
      }
    });
    notifyListeners();
  }

  Future<void> getWorkerHistory() async {
    _workerHistory.clear();
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.ref().child('history');
    final response = await _databaseReference.get();
    Map<dynamic, dynamic> extractedData =
        response.value as Map<dynamic, dynamic>;
    extractedData.forEach((key, value) {
      if (value['workerId'] == userId) {
        _workerHistory.add(History(
          description: value['description'],
          price: value['price'],
          distanceBetween: value['distance'],
          dateTime: DateTime.tryParse(value['dateTime'])!,
        ));
      }
    });
    notifyListeners();
  }
}
