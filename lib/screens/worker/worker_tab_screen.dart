import 'package:flutter/material.dart';

import 'package:murammat_app/screens/worker/worker_activity_screen.dart';
import 'package:murammat_app/screens/worker/worker_dashboard_screen.dart';
import 'package:murammat_app/screens/worker/worker_settings_screen.dart';

class WorkerTabScreen extends StatefulWidget {
  static const routeName = '/worker-tab';

  @override
  State<WorkerTabScreen> createState() => _WorkerTabScreenState();
}

class _WorkerTabScreenState extends State<WorkerTabScreen> {
  List<Map<String, Object>> _pages = [];
  int _selectedPageIndex = 0;
  Future<bool> _onWillPop() async {
    return (await false);
  }

  @override
  void initState() {
    _pages = [
      {
        'page': WorkerDashboardScreen(),
        'title': 'Worker Dashboard',
      },
      {
        'page': WorkerActivityScreen(),
        'title': 'Worker Activity',
      },
      {
        'page': WorkerSettingsScreen(),
        'title': 'Worker Settings',
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
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: <Widget>[
            _pages[_selectedPageIndex]['page'] as Widget,
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: Align(
                alignment: Alignment(0.0, 1.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: BottomNavigationBar(
                    iconSize: 30,
                    onTap: _selectPage,
                    backgroundColor: Theme.of(context).primaryColor,
                    unselectedItemColor:
                        Theme.of(context).colorScheme.secondary,
                    selectedItemColor:
                        Theme.of(context).appBarTheme.foregroundColor,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
