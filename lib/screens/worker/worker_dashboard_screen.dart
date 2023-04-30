import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WorkerDashboardScreen extends StatefulWidget {
  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  int _currentIndex = 0;
  final List imagesList = [
    "https://img.freepik.com/premium-vector/roadside-assistance-concept-broken-car-tow-truck-cartoon-man-calling-emergency-service-illustration-flat-style_136277-675.jpg?w=2000",
    "https://img.freepik.com/premium-vector/roadside-assistance-tow-truck-illustration-car-vector_178650-4113.jpg?w=2000",
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
                    child: Card(
                      margin: EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      elevation: 6.0,
                      shadowColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
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
              onPressed: () {},
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
              onPressed: () {},
              icon: Icon(
                Icons.home_repair_service,
                color: Theme.of(context).primaryColor,
              ),
              label: Text(
                'Services',
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
              onPressed: () {},
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
        ],
      ),
    );
  }
}
