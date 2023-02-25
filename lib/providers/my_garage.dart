import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GarageItems {
  final String id;
  final String? vehicleName;
  var image;
  final DateTime dateTime;
  final int? milage;
  final int? engineSize;
  final int? topSpeed;

  GarageItems({
    required this.id,
    required this.vehicleName,
    required this.image,
    required this.dateTime,
    required this.milage,
    required this.engineSize,
    required this.topSpeed,
  });
}

class ServiceLogs {
  final int? totalPrice;
  final String? serviceDetail;
  final DateTime dateTime;
  ServiceLogs({
    required this.totalPrice,
    required this.serviceDetail,
    required this.dateTime,
  });
}

class Garage with ChangeNotifier {
  List<GarageItems> _items = [];
  List<ServiceLogs> _serviceLogs = [];

  List<GarageItems> get items {
    return [..._items];
  }

  List<ServiceLogs> get serviceLogs {
    return [..._serviceLogs];
  }

  Future<void> fetchAndSetVehicles() async {
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/vehicles.json');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData.isEmpty || extractedData['error'] != null) {
      return;
    }
    final List<GarageItems> loadedVehicles = [];
    extractedData.forEach((vehicleId, vehicleData) {
      loadedVehicles.add(GarageItems(
        id: vehicleId,
        vehicleName: vehicleData['vehicleName'],
        dateTime: DateTime.tryParse(vehicleData['dateTime'])!,
        image: File(vehicleData['image']),
        milage: int.parse(vehicleData['mileage']),
        engineSize: int.parse(vehicleData['engineSize']),
        topSpeed: int.parse(vehicleData['topSpeed']),
      ));
    });
    _items = loadedVehicles;
    notifyListeners();
  }

  Future<void> addNewVehicle(GarageItems vehicle) async {
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/vehicles.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'vehicleName': vehicle.vehicleName,
            'image': vehicle.image.path,
            'dateTime': vehicle.dateTime.toIso8601String(),
            'mileage': vehicle.milage.toString(),
            'engineSize': vehicle.engineSize.toString(),
            'topSpeed': vehicle.topSpeed.toString(),
          }));
      final newVehicle = GarageItems(
        id: json.decode(response.body)['name'],
        vehicleName: vehicle.vehicleName,
        image: File((vehicle.image).path),
        dateTime: vehicle.dateTime,
        milage: vehicle.milage,
        engineSize: vehicle.engineSize,
        topSpeed: vehicle.topSpeed,
      );
      _items.add(newVehicle);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteVehicle(String existingId) async {
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/vehicles/$existingId.json');
    final existingVehicleIndex =
        _items.indexWhere((vehicle) => vehicle.id == existingId);
    GarageItems? existingVehicle = _items[existingVehicleIndex];

    _items.removeAt(existingVehicleIndex);

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingVehicleIndex, existingVehicle);
      notifyListeners();
      throw HttpException('Could not delete Vehicle');
    } else {
      existingVehicle = null;
    }
    notifyListeners();
  }

  Future<void> updateVehicle(GarageItems vehicle, String existingId) async {
    final vehicleIndex =
        _items.indexWhere((vehicle) => vehicle.id == existingId);
    if (vehicleIndex >= 0) {
      final url = Uri.parse(
          'https://murammat-b174c-default-rtdb.firebaseio.com/vehicles/$existingId.json');
      await http.patch(url,
          body: json.encode({
            'vehicleName': vehicle.vehicleName,
            'image': vehicle.image.path,
            'dateTime': vehicle.dateTime.toIso8601String(),
            'mileage': vehicle.milage.toString(),
            'engineSize': vehicle.engineSize.toString(),
            'topSpeed': vehicle.topSpeed.toString(),
          }));

      _items[vehicleIndex] = vehicle;
      notifyListeners();
    }
  }

  Future<void> addServiceLog(ServiceLogs service, String id) async {
    final url = Uri.parse(
        'https://murammat-b174c-default-rtdb.firebaseio.com/vehicles/$id/services.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'serviceDetail': service.serviceDetail,
            'totalPrice': service.totalPrice,
            'dateTime': service.dateTime.toIso8601String(),
          }));
      final newServiceLog = ServiceLogs(
          totalPrice: service.totalPrice,
          serviceDetail: service.serviceDetail,
          dateTime: service.dateTime);
      _serviceLogs.add(newServiceLog);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
