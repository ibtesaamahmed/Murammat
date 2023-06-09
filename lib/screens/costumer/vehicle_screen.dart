import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/my_garage.dart';
import '/screens/costumer/service_logs_screen.dart';

class VehicleScreen extends StatelessWidget {
  final int existingIndex;

  VehicleScreen({required this.existingIndex});

  @override
  Widget build(BuildContext context) {
    final vehicleData = Provider.of<Garage>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 250,
            child: Image.file(
              File(vehicleData.items[existingIndex].image.path),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Vehicle Name',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold)),
                      Text(
                          vehicleData.items[existingIndex].vehicleName
                              .toString(),
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Center(
                      child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: 280,
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Mileage (Km)',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold)),
                      Text(vehicleData.items[existingIndex].milage.toString(),
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Center(
                      child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: 280,
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Engine Size (cc)',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold)),
                      Text(
                          vehicleData.items[existingIndex].engineSize
                              .toString(),
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Center(
                      child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: 280,
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Top Speed (Km/h)',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold)),
                      Text(vehicleData.items[existingIndex].topSpeed.toString(),
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Center(
                      child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: 280,
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServiceLogsScreen(
                              vehicleData.items[existingIndex].id)));
                },
                icon: Icon(Icons.home_repair_service_rounded),
                label: Text('Service Logs')),
          ),
        ],
      ),
    );
  }
}
