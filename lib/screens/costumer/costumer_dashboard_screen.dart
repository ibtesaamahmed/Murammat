import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:murammat_app/screens/costumer/customer_appointment_screen.dart';
import 'package:murammat_app/screens/costumer/my_garage_screen.dart';
import 'package:murammat_app/screens/costumer/services_screen.dart';
import 'package:murammat_app/screens/costumer/nearby_shops_screen.dart';

class CostumerDashboardScreen extends StatefulWidget {
  @override
  State<CostumerDashboardScreen> createState() =>
      _CostumerDashboardScreenState();
}

class _CostumerDashboardScreenState extends State<CostumerDashboardScreen> {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              /*
                  Services
              */
              Container(
                width: 150,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 4)),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(ServicesScreen.routeName);
                  },
                  icon: Icon(
                    Icons.home_repair_service,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    'Services',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).appBarTheme.foregroundColor,
                    fixedSize: Size(120, 100),
                  ),
                ),
              ),
              /*
                  Shops
              */
              Container(
                width: 150,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 4)),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(NearByShopsScreen.routeName);
                  },
                  icon: Icon(
                    Icons.shop,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    'Shops',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).appBarTheme.foregroundColor,
                    fixedSize: Size(120, 100),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              /*
                  At Door Step
              */
              Container(
                width: 150,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 4)),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(CutomerAppointmentScreen.routeName);
                  },
                  icon: Icon(
                    Icons.door_sliding_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    'Appointment',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).appBarTheme.foregroundColor,
                    fixedSize: Size(120, 100),
                  ),
                ),
              ),
              /*
                  My Garage
              */
              Container(
                width: 150,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 4)),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(MyGarageScreen.routeName);
                  },
                  icon: Icon(
                    Icons.garage,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    'Garage',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).appBarTheme.foregroundColor,
                    fixedSize: Size(120, 100),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
