import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:murammat_app/screens/worker/my_shop_screen.dart';
import 'package:murammat_app/screens/worker/request_screen.dart';
import 'package:murammat_app/screens/worker/worker_appointment_screen.dart';
import 'package:provider/provider.dart';
import 'package:murammat_app/providers/worker.dart';

class WorkerDashboardScreen extends StatefulWidget {
  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  int _currentIndex = 0;
  final List imagesList = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIrGtbwy6PcwHI7DpwfNgP42OdPgu3s_9mfg&usqp=CAU",
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              //  autoPlayAnimationDuration: Duration(microseconds: 2000),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: imagesList
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor,
                              blurRadius: 4.0,
                              offset: Offset(
                                0.0,
                                1.0,
                              ),
                            ),
                          ],
                          border: Border.all(
                              width: 5, color: Theme.of(context).primaryColor)),
                      // elevation: 6.0,
                      // shadowColor: Theme.of(context).primaryColor,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(30.0),
                      // ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.zero,
                        ),
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                              item,
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imagesList.map((urlOfItem) {
              int index = imagesList.indexOf(urlOfItem);
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Color.fromRGBO(0, 0, 0, 0.8)
                      : Color.fromRGBO(0, 0, 0, 0.3),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 4)),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RequestScreen(),
                ));
              },
              icon: Icon(
                Icons.notifications_active,
                color: Theme.of(context).primaryColor,
              ),
              label: Text(
                'Requests',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
                fixedSize: Size(300, 60),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 4)),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyShopScreen(),
                ));
              },
              icon: Icon(
                Icons.shop,
                color: Theme.of(context).primaryColor,
              ),
              label: Text(
                'My Shop',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
                fixedSize: Size(300, 60),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 4)),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WorkerAppointmentScreen(),
                ));
              },
              icon: Icon(
                Icons.home_repair_service,
                color: Theme.of(context).primaryColor,
              ),
              label: Text(
                'Appointments',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).appBarTheme.foregroundColor,
                fixedSize: Size(300, 60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
