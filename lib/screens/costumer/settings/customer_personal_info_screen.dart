import 'package:flutter/material.dart';
import 'package:murammat_app/providers/auth.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:murammat_app/widgets/edit_customer_info.dart';
import 'package:provider/provider.dart';

class CustomerPersonalInfo extends StatefulWidget {
  @override
  State<CustomerPersonalInfo> createState() => _CustomerPersonalInfoState();
}

class _CustomerPersonalInfoState extends State<CustomerPersonalInfo> {
  Future<void> _fetchCustomerInfo(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).getCustomerInfo();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => _fetchCustomerInfo(context));
    super.initState();
  }

  void _editCustomerInfo(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        backgroundColor: Theme.of(ctx).canvasColor,
        isScrollControlled: true,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: EditCustomerInfo(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print('building');
    return Scaffold(
        appBar: AppBar(
          title: Text('Personal Info'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editCustomerInfo(context),
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: _fetchCustomerInfo(context),
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
                                value.customerInfo.firstName +
                                    ' ' +
                                    value.customerInfo.lastName,
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
                                value.customerInfo.phoneNo,
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
                                value.customerInfo.email,
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
                                value.customerInfo.areaOrSector,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.house,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                value.customerInfo.houseNo,
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
                                value.customerInfo.streetNo,
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
                                value.customerInfo.city,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                value.customerInfo.gender,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
        ));
  }
}
