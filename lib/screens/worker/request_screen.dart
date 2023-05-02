import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _initialCameraPosition = CameraPosition(
    target: LatLng(
        double.parse('33.63151504740167'), double.parse('73.08072607369083')),
    zoom: 15,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(initialCameraPosition: _initialCameraPosition),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20, bottom: 20),
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.my_location,
                    color: Theme.of(context).primaryColor,
                    size: 40,
                  )),
            ),
            Container(
              height: 300.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(30),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                // color: Theme.of(context).canvasColor,
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor,
                    blurRadius: 6.0,
                    // spreadRadius: 2.0,
                    offset: Offset(
                      0.0,
                      1.0,
                    ),
                  ),
                ],
              ),
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Image.asset('assets/images/logo.png',
                          color: Theme.of(context).primaryColor),
                      title: Text('Incoming Request'),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.location_history,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text('5 km away')
                        ]),
                      ),
                      trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.done,
                                  color: Theme.of(context).primaryColor,
                                  size: 35,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.cancel,
                                  color: Theme.of(context).errorColor,
                                  size: 35,
                                ))
                          ]),
                    ),
                  ),
                )
              ]),
            )
          ],
        ),
      ],
    ));
  }
}
