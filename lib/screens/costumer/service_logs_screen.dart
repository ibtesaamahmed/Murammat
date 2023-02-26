import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:murammat_app/providers/my_garage.dart';
import 'package:murammat_app/screens/costumer/edit_service_logs_screen.dart';
import 'package:murammat_app/widgets/add_new_servicelog.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class ServiceLogsScreen extends StatefulWidget {
  final String existingVehicleId;
  ServiceLogsScreen(this.existingVehicleId);

  @override
  State<ServiceLogsScreen> createState() => _ServiceLogsScreenState();
}

class _ServiceLogsScreenState extends State<ServiceLogsScreen> {
  Future<void> _refreshServiceLogs(BuildContext context, String id) async {
    await Provider.of<Garage>(context, listen: false)
        .fetchAndSetServiceLogs(id);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero)
        .then((_) => _refreshServiceLogs(context, widget.existingVehicleId));
    super.initState();
  }

  void addNewLog(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Theme.of(ctx).canvasColor,
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddNewServiceLog(widget.existingVehicleId),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Service Logs'),
        actions: [
          IconButton(
              onPressed: () => addNewLog(context), icon: Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: _refreshServiceLogs(context, widget.existingVehicleId),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CustomCircularProgressIndicator())
            : Container(
                child: RefreshIndicator(
                color: Theme.of(context).primaryColor,
                onRefresh: () =>
                    _refreshServiceLogs(context, widget.existingVehicleId),
                child: Consumer<Garage>(
                  builder: (context, value, child) => Column(children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          child: Card(
                              elevation: 5,
                              margin: EdgeInsets.all(20),
                              child: ListTile(
                                leading: Container(
                                  padding: EdgeInsets.only(top: 10, right: 10),
                                  child: Text(
                                    'Rs. ' +
                                        value.serviceLogs[index].totalPrice
                                            .toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  value.serviceLogs[index].serviceDetail
                                      .toString(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  DateFormat.yMMMEd().format(
                                      value.serviceLogs[index].dateTime),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                                trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditServiceLogScreen(
                                                          existingServiceId:
                                                              value
                                                                  .serviceLogs[
                                                                      index]
                                                                  .id,
                                                          existingVehicleId: widget
                                                              .existingVehicleId,
                                                        )));
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            try {
                                              await value.deleteServiceLog(
                                                  value.serviceLogs[index].id,
                                                  widget.existingVehicleId);
                                              print('deleted');
                                              Fluttertoast.showToast(
                                                  msg: 'Deleted Successfully!',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  textColor: Colors.white,
                                                  fontSize: 12.0);
                                            } catch (error) {
                                              scaffold.showSnackBar(SnackBar(
                                                  content: Text(
                                                'Deleting Failed!',
                                                textAlign: TextAlign.center,
                                              )));
                                            }
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Theme.of(context).errorColor,
                                          )),
                                    ]),
                              )),
                        );
                      },
                      itemCount: value.serviceLogs.length,
                    ))
                  ]),
                ),
              )),
      ),
    );
  }
}
