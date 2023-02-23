import 'package:flutter/material.dart';

import 'package:murammat_app/screens/costumer/costumer_activity_screen.dart';
import 'package:murammat_app/screens/costumer/costumer_dashboard_screen.dart';
import 'package:murammat_app/screens/costumer/costumer_settings_screen.dart';

class CostumerTabScreen extends StatefulWidget {
  static const routeName = '/costumer-tab';

  @override
  State<CostumerTabScreen> createState() => _CostumerTabScreenState();
}

class _CostumerTabScreenState extends State<CostumerTabScreen> {
  List<Map<String, Object>> _pages = [];
  int _selectedPageIndex = 0;
  Future<bool> _onWillPop() async {
    return (await false);
  }

  @override
  void initState() {
    _pages = [
      {
        'page': CostumerDashboardScreen(),
        'title': 'Costumer Dashboard',
      },
      {
        'page': CostumerActivityScreen(),
        'title': 'Costumer Activity',
      },
      {
        'page': CostumerSettingsScreen(),
        'title': 'Costumer Settings',
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_pages[_selectedPageIndex]['title'].toString()),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.logout),
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: _pages[_selectedPageIndex]['page'] as Widget,
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          onTap: _selectPage,
          backgroundColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).accentColor,
          selectedItemColor: Theme.of(context).canvasColor,
          currentIndex: _selectedPageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: Theme.of(context).primaryColor,
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_activity),
              backgroundColor: Theme.of(context).primaryColor,
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              backgroundColor: Theme.of(context).primaryColor,
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
