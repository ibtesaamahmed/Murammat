import 'dart:io';

import 'package:flutter/material.dart';
import 'package:murammat_app/providers/my_garage.dart';
import 'package:provider/provider.dart';

class VehicleScreen extends StatelessWidget {
  final int existingIndex;

  VehicleScreen({required this.existingIndex});

  @override
  Widget build(BuildContext context) {
    final vehicleData = Provider.of<Garage>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.edit_rounded))],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Vehicle Name',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Mileage (Km)',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Engine Size (cc)',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Top Speed (Km/h)',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(vehicleData.items[existingIndex].vehicleName.toString(),
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('2000', style: TextStyle(fontSize: 18)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('1500', style: TextStyle(fontSize: 18)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('180', style: TextStyle(fontSize: 18)),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
              onPressed: () {},
              icon: Icon(Icons.home_repair_service_rounded),
              label: Text('Service Logs')),
        ],
      ),
    );
  }
}
