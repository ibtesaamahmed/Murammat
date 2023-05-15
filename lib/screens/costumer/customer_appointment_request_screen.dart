import 'package:flutter/material.dart';
import 'package:murammat_app/providers/appointment.dart';
import 'package:provider/provider.dart';

class CustomerAppointmentRequestScreen extends StatefulWidget {
  const CustomerAppointmentRequestScreen({super.key});

  @override
  State<CustomerAppointmentRequestScreen> createState() =>
      _CustomerAppointmentRequestScreenState();
}

class _CustomerAppointmentRequestScreenState
    extends State<CustomerAppointmentRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Request')),
      body: ElevatedButton(
        child: Text('press'),
        onPressed: () {
          Provider.of<Appointments>(context, listen: false)
              .searchWorkerForAppointment();
        },
      ),
    );
  }
}
