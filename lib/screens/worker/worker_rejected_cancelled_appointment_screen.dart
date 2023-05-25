import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/appointment.dart';
import '../../widgets/custom_circular_progress_indicator.dart';

class WorkerRejectedOrCancelledAppointmentScreen extends StatefulWidget {
  const WorkerRejectedOrCancelledAppointmentScreen({super.key});

  @override
  State<WorkerRejectedOrCancelledAppointmentScreen> createState() =>
      _WorkerRejectedOrCancelledAppointmentScreenState();
}

class _WorkerRejectedOrCancelledAppointmentScreenState
    extends State<WorkerRejectedOrCancelledAppointmentScreen> {
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Appointments>(context, listen: false)
        .getAppointments('worker');
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
                          .rejectedAppointments.isEmpty
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
                                'No Rejected Appointments',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                  child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: value.rejectedAppointments.length,
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
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                value
                                                    .rejectedAppointments[index]
                                                    .serviceDescription,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              Text(
                                                value
                                                        .rejectedAppointments[
                                                            index]
                                                        .distanceBetween +
                                                    ' km away',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[900]),
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(
                                              '${DateFormat.yMd().format(value.rejectedAppointments[index].date)}' +
                                                  ' ${value.rejectedAppointments[index].time}'),
                                          trailing: Text(
                                            value.rejectedAppointments[index]
                                                .status,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor),
                                          )),
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
