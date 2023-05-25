import 'package:flutter/material.dart';
import 'package:murammat_app/screens/costumer/customer_accepted_appointment_screen.dart';
import 'package:murammat_app/screens/costumer/customer_appointment_request_screen.dart';
import 'package:murammat_app/screens/costumer/customer_pending_appointment_screen.dart';
import 'package:murammat_app/screens/costumer/customer_rejected_cancelled_appointment_screen.dart';

class CutomerAppointmentScreen extends StatefulWidget {
  static const routeName = '/customer-appointment-screen';

  @override
  State<CutomerAppointmentScreen> createState() =>
      _CutomerAppointmentScreenState();
}

class _CutomerAppointmentScreenState extends State<CutomerAppointmentScreen> {
  List<Map<String, Object>> _pages = [];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': CustomerAcceptedAppointmentScreen(),
        'title': 'Accepted',
      },
      {
        'page': CustomerPendingAppointmentScreen(),
        'title': 'Pending',
      },
      {
        'page': CustomerRejectedOrCancelledAppointmentScreen(),
        'title': 'Rejected/Cancelled',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title'].toString()),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CustomerAppointmentRequestScreen(),
              ));
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        selectedItemColor: Theme.of(context).appBarTheme.foregroundColor,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Accepted',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending),
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Rejected',
          ),
        ],
      ),
    );
  }
}
