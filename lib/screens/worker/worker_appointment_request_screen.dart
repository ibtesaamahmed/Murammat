import 'package:flutter/material.dart';

class WorkerAppointmentRequestsScreen extends StatefulWidget {
  const WorkerAppointmentRequestsScreen({super.key});

  @override
  State<WorkerAppointmentRequestsScreen> createState() =>
      _WorkerAppointmentScreenState();
}

class _WorkerAppointmentScreenState
    extends State<WorkerAppointmentRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointment Requests')),
    );
  }
}
