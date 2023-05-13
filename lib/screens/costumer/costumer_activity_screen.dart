import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:murammat_app/providers/history.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../providers/customer.dart';

class CostumerActivityScreen extends StatefulWidget {
  @override
  State<CostumerActivityScreen> createState() => _CostumerActivityScreenState();
}

class _CostumerActivityScreenState extends State<CostumerActivityScreen> {
  Future<void> _refreshVehicles(BuildContext context) async {
    await Provider.of<MyHistory>(context, listen: false).getCustomerHistory();
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((_) => _refreshVehicles(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refreshVehicles(context),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? CustomCircularProgressIndicator()
          : Container(
              child: RefreshIndicator(
                  onRefresh: () => _refreshVehicles(context),
                  color: Theme.of(context).primaryColor,
                  child: Consumer<MyHistory>(
                      builder: (context, value, child) => value
                              .customerHistory.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    child: Image.asset(
                                        "assets/images/waiting.png"),
                                    height: 50,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'No Activity Yet!',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )
                                ],
                              ),
                            )
                          : Column(
                              children: <Widget>[
                                Expanded(
                                    child: ListView.builder(
                                        itemCount: value.customerHistory.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 5,
                                              child: ListTile(
                                                leading: Image.asset(
                                                    'assets/images/logo.png',
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                title: Text(
                                                  value.customerHistory[index]
                                                      .description,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                                'MM-dd-yy h:mm a')
                                                            .format(value
                                                                .customerHistory[
                                                                    index]
                                                                .dateTime),
                                                      ),
                                                      Text(value
                                                              .customerHistory[
                                                                  index]
                                                              .distanceBetween +
                                                          ' km')
                                                    ]),
                                                trailing: Text(
                                                  value.customerHistory[index]
                                                          .price +
                                                      ' Rs',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                          );
                                        }))
                              ],
                            ))),
            ),
    );
  }
}
