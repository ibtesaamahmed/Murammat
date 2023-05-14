import 'package:flutter/material.dart';

class AtDoorStepServicesScreen extends StatefulWidget {
  static const routeName = '/at-doorstep-services';

  @override
  State<AtDoorStepServicesScreen> createState() =>
      _AtDoorStepServicesScreenState();
}

class _AtDoorStepServicesScreenState extends State<AtDoorStepServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doorstep Services')),
      body: Container(),
    );
  }
}
