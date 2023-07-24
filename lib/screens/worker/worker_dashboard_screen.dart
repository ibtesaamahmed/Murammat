import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:murammat_app/screens/worker/my_shop_screen.dart';
import 'package:murammat_app/screens/worker/request_screen.dart';
import 'package:murammat_app/screens/worker/worker_appointment_screen.dart';

class WorkerDashboardScreen extends StatefulWidget {
  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  int _currentIndex = 0;
  final List imagesList = [
    "https://newsroom.aaa.com/wp-content/uploads/2016/07/Roadside-Assistance.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIrGtbwy6PcwHI7DpwfNgP42OdPgu3s_9mfg&usqp=CAU",
    "https://cdn.hswstatic.com/gif/cost-of-roadside-assistance-1.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              // autoPlayAnimationDuration: Duration(microseconds: 2000),
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
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Theme.of(context).primaryColor,
                        //     blurRadius: 4.0,
                        //     offset: Offset(
                        //       0.0,
                        //       1.0,
                        //     ),
                        //   ),
                        // ],

                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            width: 3, color: Theme.of(context).primaryColor),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
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
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RequestScreen(),
              ));
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Image.asset(
                  'assets/images/services.png',
                  fit: BoxFit.cover,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Service',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MyShopScreen()));
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Image.asset(
                  'assets/images/shops.png',
                  fit: BoxFit.cover,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Shops',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WorkerAppointmentScreen()));
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Image.asset(
                  'assets/images/appointment.png',
                  fit: BoxFit.cover,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Appointment',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}
