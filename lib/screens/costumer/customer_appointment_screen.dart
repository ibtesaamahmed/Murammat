import 'package:flutter/material.dart';
import 'package:murammat_app/screens/costumer/customer_appointment_request_screen.dart';

class CutomerAppointmentScreen extends StatefulWidget {
  static const routeName = '/customer-appointment-screen';

  @override
  State<CutomerAppointmentScreen> createState() =>
      _CutomerAppointmentScreenState();
}

class _CutomerAppointmentScreenState extends State<CutomerAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CustomerAppointmentRequestScreen(),
                ));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
