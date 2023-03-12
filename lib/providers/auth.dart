import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

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

  Future<void> signUp(String email, String password, String role) async {
    // return _authentication(email, password, 'accounts:signUp');
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
      await http.post(url2, body: json.encode({'id': _userId}));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login(String email, String password, String role) async {
    // return _authentication(email, password, 'accounts:signInWithPassword');
    const urlSegment = 'accounts:signInWithPassword';
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyA6zCS41bJZaQicQ1rXUQo9qqhCvUvA5jA');
    final url2 = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/users/$role.json?auth=$_token');
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
      final res = await http.get(url2);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      print(extractedData.toString());
      if (extractedData.isEmpty || extractedData['error'] != null) {
        throw HttpException('Error');
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
