import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/appointment.dart';
import '../../widgets/custom_circular_progress_indicator.dart';

class CustomerPendingAppointmentScreen extends StatefulWidget {
  const CustomerPendingAppointmentScreen({super.key});

  @override
  State<CustomerPendingAppointmentScreen> createState() =>
      _CustomerPendingAppointmentScreenState();
}

class _CustomerPendingAppointmentScreenState
    extends State<CustomerPendingAppointmentScreen> {
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Appointments>(context, listen: false)
        .getAppointments('customer');
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => _refresh(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refresh(context),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? CustomCircularProgressIndicator()
          : Container(
              child: RefreshIndicator(
                onRefresh: () => _refresh(context),
                child: Consumer<Appointments>(
                  builder: (context, value, child) => value
                          .pendingAppointments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                child: Image.asset("assets/images/waiting.png"),
                                height: 50,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No Pending Appointments',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                  child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: value.pendingAppointments.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, bottom: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: ListTile(
                                        style: ListTileStyle.list,
                                        leading: Image.asset(
                                            height: 30,
                                            width: 30,
                                            fit: BoxFit.cover,
                                            'assets/images/logo.png',
                                            color:
                                                Theme.of(context).primaryColor),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              value.pendingAppointments[index]
                                                  .serviceDescription,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            Text(
                                              value.pendingAppointments[index]
                                                      .distanceBetween +
                                                  ' km away',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[900]),
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                            '${DateFormat.yMd().format(value.pendingAppointments[index].date)}' +
                                                ' ${value.pendingAppointments[index].time}'),
                                        trailing: ElevatedButton(
                                            onPressed: () async {
                                              await value
                                                  .cancelAppointmentCustomer(
                                                      value
                                                          .pendingAppointments[
                                                              index]
                                                          .appointmentId,
                                                      'customer');
                                              Fluttertoast.showToast(
                                                  msg: 'Appointment Cancelled!',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  textColor: Colors.white,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.8),
                                                  fontSize: 12.0);
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                      ),
                                    ),
                                  );
                                },
                              ))
                            ],
                          ),
                        ),
                ),
              ),
            ),
    );
  }
}
