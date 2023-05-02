import 'package:flutter/material.dart';
import 'package:murammat_app/providers/auth.dart';
import 'package:murammat_app/widgets/edit_worker_info.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_circular_progress_indicator.dart';

class WorkerPersonalInfo extends StatefulWidget {
  const WorkerPersonalInfo({super.key});

  @override
  State<WorkerPersonalInfo> createState() => _WorkerPersonalInfoState();
}

class _WorkerPersonalInfoState extends State<WorkerPersonalInfo> {
  Future<void> _fetchWorkerInfo(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).getWorkerInfo();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => _fetchWorkerInfo(context));
    super.initState();
  }

  void _editWorkerInfo(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        backgroundColor: Theme.of(ctx).canvasColor,
        isScrollControlled: true,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: EditWorkerInfo(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editWorkerInfo(context);
                }),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchWorkerInfo(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CustomCircularProgressIndicator(),
                  )
                : Consumer<Auth>(
                    builder: (context, value, child) => SingleChildScrollView(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.person_pin,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              value.workerInfo.firstName +
                                  ' ' +
                                  value.workerInfo.lastName,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.phone,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              value.workerInfo.phoneNo,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.mail,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              value.workerInfo.email,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.shop,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              value.workerInfo.shopName,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.shop_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              value.workerInfo.shopNo,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.streetview,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              value.workerInfo.streetNo,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.place,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              value.workerInfo.areaOrSector,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.location_city,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              value.workerInfo.city,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
      ),
    );
  }
}
