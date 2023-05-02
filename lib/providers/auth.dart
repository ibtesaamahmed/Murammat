import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class CustomerInfo {
  String id;
  String firstName;
  String lastName;
  String phoneNo;
  String email;
  String gender;
  String areaOrSector;
  String houseNo;
  String streetNo;
  String city;
  CustomerInfo(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNo,
      required this.gender,
      required this.areaOrSector,
      required this.city,
      required this.houseNo,
      required this.streetNo});
}

class WorkerInfo {
  String id;
  String firstName;
  String lastName;
  String phoneNo;
  String email;
  String shopName;
  String shopNo;
  String streetNo;
  String areaOrSector;
  String city;

  WorkerInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    required this.areaOrSector,
    required this.city,
    required this.shopName,
    required this.shopNo,
    required this.streetNo,
  });
}

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  CustomerInfo _customerInfo = CustomerInfo(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      phoneNo: '',
      gender: '',
      areaOrSector: '',
      city: '',
      houseNo: '',
      streetNo: '');

  CustomerInfo get customerInfo {
    return _customerInfo;
  }

  WorkerInfo _workerInfo = WorkerInfo(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      phoneNo: '',
      areaOrSector: '',
      city: '',
      shopName: '',
      shopNo: '',
      streetNo: '');

  WorkerInfo get workerInfo {
    return _workerInfo;
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String? get userId {
    if (_userId != null) {
      return _userId;
    } else {
      return null;
    }
  }

  Future<void> signUp(
      String email,
      String password,
      String role,
      String firstName,
      String lastName,
      String phoneNo,
      String houseNo,
      String streetNo,
      String areaOrSector,
      String city,
      String gender,
      [final shopName]) async {
    const urlSegment = 'accounts:signUp';
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyA6zCS41bJZaQicQ1rXUQo9qqhCvUvA5jA');

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      final url2 = Uri.parse(
          'https://murammat-b174c-default-rtdb.firebaseio.com/users/$role.json?auth=$_token?');
      if (shopName == null) {
        await http.post(url2,
            body: json.encode({
              'id': _userId,
              'firstName': firstName,
              'lastName': lastName,
              'gender': gender,
              'phoneNo': phoneNo,
              'houseNo': houseNo,
              'streetNo': streetNo,
              'areaOrSector': areaOrSector,
              'city': city,
              'email': email,
            }));
        notifyListeners();
      } else {
        await http.post(url2,
            body: json.encode({
              'id': _userId,
              'email': email,
              'firstName': firstName,
              'lastName': lastName,
              'phoneNo': phoneNo,
              'shopNo': houseNo,
              'streetNo': streetNo,
              'areaOrSector': areaOrSector,
              'city': city,
              'shopName': shopName.toString(),
            }));
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login(String email, String password, String role) async {
    const urlSegment = 'accounts:signInWithPassword';
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyA6zCS41bJZaQicQ1rXUQo9qqhCvUvA5jA');

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      final url2 = Uri.parse(
          'https://murammat-b174c-default-rtdb.firebaseio.com/users/$role.json?auth=$_token');
      final res = await http.get(url2);
      List<String> userIds = [];
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData.isEmpty || extractedData['error'] != null) {
        throw HttpException('Error');
      } else {
        extractedData.forEach((_, userData) {
          userIds.add(userData['id']);
          // if (userData['id'] != _userId) {
          //   throw HttpException('Error');
          // }
        });
        if (!userIds.contains(_userId)) {
          throw HttpException('Error');
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // CUSTOMER
  Future<void> getCustomerInfo() async {
    var extractedId;
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/users/customers.json?auth=$_token');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((id, data) {
        if (data['id'] == _userId) {
          extractedId = id;
        }
      });
    } catch (error) {
      throw error;
    }

    final url2 = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/users/customers/$extractedId.json?auth=$_token');
    try {
      final res = await http.get(url2);
      final userData = json.decode(res.body) as Map<String, dynamic>;
      _customerInfo = CustomerInfo(
        id: extractedId,
        firstName: userData['firstName'],
        lastName: userData['lastName'],
        phoneNo: userData['phoneNo'],
        email: userData['email'],
        gender: userData['gender'],
        areaOrSector: userData['areaOrSector'],
        city: userData['city'],
        houseNo: userData['houseNo'],
        streetNo: userData['streetNo'],
      );
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> editCustomerInfo(String id, CustomerInfo ci) async {
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/users/customers/$id.json?auth=$_token');

    try {
      await http.patch(url,
          body: json.encode({
            'firstName': ci.firstName,
            'lastName': ci.lastName,
            'phoneNo': ci.phoneNo,
            'gender': ci.gender,
            'areaOrSector': ci.areaOrSector,
            'houseNo': ci.houseNo,
            'streetNo': ci.streetNo,
            'city': ci.city,
          }));
      _customerInfo = ci;
    } catch (error) {
      print(error);
      throw error;
    }
    notifyListeners();
  }

  Future<void> postHelpMessage(String message, String role) async {
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/help/$role.json?auth=$_token');
    try {
      if (role == 'customers') {
        await http.post(url,
            body: json.encode({
              'message': message,
              'userId': _userId,
              'name': _customerInfo.firstName + ' ' + _customerInfo.lastName,
              'email': _customerInfo.email,
            }));
      } else {
        await http.post(url,
            body: json.encode({
              'message': message,
              'userId': _userId,
              'name': _workerInfo.firstName + ' ' + _workerInfo.lastName,
              'email': _workerInfo.email,
            }));
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> postRatingsAndReviews(
      double rating, String review, String role) async {
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/reviews/$role.json?auth=$_token');
    try {
      if (role == 'customers') {
        await getCustomerInfo();
        await http.post(url,
            body: json.encode({
              'userId': _userId,
              'email': _customerInfo.email,
              'name': _customerInfo.firstName + ' ' + _customerInfo.lastName,
              'rating': rating.toString(),
              'review': review,
            }));
      } else {
        await getWorkerInfo();
        await http.post(url,
            body: json.encode({
              'userId': _userId,
              'email': _workerInfo.email,
              'name': _workerInfo.firstName + ' ' + _workerInfo.lastName,
              'rating': rating.toString(),
              'review': review,
            }));
      }
    } catch (error) {
      throw error;
    }
  }
  // WORKER

  Future<void> getWorkerInfo() async {
    var extractedId;
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/users/workers.json?auth=$_token');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((id, data) {
        if (data['id'] == _userId) {
          extractedId = id;
        }
      });
    } catch (error) {
      throw error;
    }
    final url2 = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/users/workers/$extractedId.json?auth=$_token');
    try {
      final res = await http.get(url2);
      final userData = json.decode(res.body) as Map<String, dynamic>;
      _workerInfo = WorkerInfo(
        id: extractedId,
        firstName: userData['firstName'],
        lastName: userData['lastName'],
        phoneNo: userData['phoneNo'],
        email: userData['email'],
        areaOrSector: userData['areaOrSector'],
        city: userData['city'],
        streetNo: userData['streetNo'],
        shopNo: userData['shopNo'],
        shopName: userData['shopName'],
      );
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> editWorkerInfo(
      String id, String firstName, String lastName, String phoneNo) async {
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/users/workers/$id.json?auth=$_token');

    try {
      await http.patch(url,
          body: json.encode({
            'firstName': firstName,
            'lastName': lastName,
            'phoneNo': phoneNo,
          }));
      _workerInfo.firstName = firstName;
      _workerInfo.lastName = lastName;
      _workerInfo.phoneNo = phoneNo;
    } catch (error) {
      print(error);
      throw error;
    }
    notifyListeners();
  }

  Future<void> editMyShop(String id, String shopName, String shopNo,
      String areaOrSector, String streetNo, String city) async {
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/users/workers/$id.json?auth=$_token');
    try {
      await http.patch(url,
          body: json.encode({
            'shopName': shopName,
            'shopNo': shopNo,
            'areaOrSector': areaOrSector,
            'streetNo': streetNo,
            'city': city,
          }));
      _workerInfo.shopName = shopName;
      _workerInfo.shopNo = shopNo;
      _workerInfo.areaOrSector = areaOrSector;
      _workerInfo.streetNo = streetNo;
      _workerInfo.city = city;
    } catch (error) {
      print(error);
      throw error;
    }
    notifyListeners();
  }
}
