import 'package:flutter/material.dart';
import 'package:murammat_app/providers/appointment.dart';
import 'package:provider/provider.dart';

class WorkerAppointmentScreen extends StatefulWidget {
  const WorkerAppointmentScreen({super.key});

  @override
  State<WorkerAppointmentScreen> createState() =>
      _WorkerAppointmentScreenState();
}

class _WorkerAppointmentScreenState extends State<WorkerAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointments')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Provider.of<Appointments>(context, listen: false)
                      .setAppointmentAvailability();
                },
                child: Text('Set Available')),
          )
        ],
      ),
    );
  }
}
