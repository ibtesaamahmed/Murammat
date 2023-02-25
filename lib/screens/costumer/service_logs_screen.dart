import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:murammat_app/providers/my_garage.dart';
import 'package:murammat_app/widgets/add_new_servicelog.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class ServiceLogsScreen extends StatelessWidget {
  final String existingId;
  ServiceLogsScreen(this.existingId);

  void addNewLog(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Theme.of(ctx).canvasColor,
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddNewServiceLog(existingId),
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
        future: null,
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? CustomCircularProgressIndicator()
            : Container(
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
                                DateFormat.yMMMEd()
                                    .format(value.serviceLogs[index].dateTime),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.edit,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                    IconButton(
                                        onPressed: () async {},
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
              )),
      ),
    );
  }
}
