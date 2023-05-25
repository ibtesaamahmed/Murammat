import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:murammat_app/screens/costumer/vehicle_screen.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
import '../../providers/my_garage.dart';
import '/screens/costumer/edit_garage_items_screen.dart';
import '/widgets/add_new_vehicle.dart';

class MyGarageScreen extends StatefulWidget {
  static const routeName = '/garage';

  @override
  State<MyGarageScreen> createState() => _MyGarageScreenState();
}

class _MyGarageScreenState extends State<MyGarageScreen> {
  Future<void> _refreshVehicles(BuildContext context) async {
    await Provider.of<Garage>(context, listen: false).fetchAndSetVehicles();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => _refreshVehicles(context));
    super.initState();
  }

  void addNewVehicle(ctx) {
    showModalBottomSheet(
      backgroundColor: Theme.of(ctx).canvasColor,
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddNewVehicle(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    // final carGarageItems = Provider.of<Garage>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Garage'),
        actions: [
          IconButton(
              onPressed: () => addNewVehicle(context), icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _refreshVehicles(context),
        builder: ((context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CustomCircularProgressIndicator(),
              )
            : Container(
                child: RefreshIndicator(
                    color: Theme.of(context).primaryColor,
                    child: Consumer<Garage>(
                      builder: ((context, value, child) => value.items.isEmpty
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
                                    'No Vehicles Added Yet!',
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
                                    shrinkWrap: true,
                                    itemBuilder: ((ctx, index) {
                                      return Container(
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 5,
                                          child: GestureDetector(
                                            onTap: (() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          VehicleScreen(
                                                              existingIndex:
                                                                  index)));
                                            }),
                                            child: ListTile(
                                              leading: SizedBox(
                                                child: Image.file(
                                                  File(
                                                      (value.items[index].image)
                                                          .path),
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              title: Text(value
                                                  .items[index].vehicleName
                                                  .toString()),
                                              subtitle: Text(DateFormat.yMMMEd()
                                                  .format(value
                                                      .items[index].dateTime)),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => EditGarageItemsScreen(
                                                                    existingId: value
                                                                        .items[
                                                                            index]
                                                                        .id)));
                                                      },
                                                      icon: Icon(
                                                        Icons.edit,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      )),
                                                  IconButton(
                                                      onPressed: () async {
                                                        try {
                                                          await value
                                                              .deleteVehicle(
                                                                  value
                                                                      .items[
                                                                          index]
                                                                      .id);
                                                          print('deleted');
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Deleted Successfully!',
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              textColor:
                                                                  Colors.white,
                                                              backgroundColor: Theme
                                                                      .of(
                                                                          context)
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.8),
                                                              fontSize: 12.0);
                                                        } catch (error) {
                                                          scaffold.showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                            'Deleting Failed!',
                                                            textAlign: TextAlign
                                                                .center,
                                                          )));
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Theme.of(context)
                                                            .errorColor,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                    itemCount: value.items.length,
                                  ),
                                ),
                              ],
                            )),
                    ),
                    onRefresh: (() => _refreshVehicles(context))),
              )),
      ),
    );
  }
}
      
//       Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               itemBuilder: ((ctx, index) {
//                 return Container(
//                   child: Card(
//                     color: Colors.white,
//                     elevation: 5,
//                     child: GestureDetector(
//                       onTap: (() {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     VehicleScreen(existingIndex: index)));
//                       }),
//                       child: ListTile(
//                         leading: Container(
//                           child: Image.file(
//                               File((carGarageItems.items[index].image).path)),
//                         ),
//                         title: Text(
//                             carGarageItems.items[index].vehicleName.toString()),
//                         subtitle: Text(DateFormat.yMMMEd()
//                             .format(carGarageItems.items[index].dateTime)),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             IconButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               EditGarageItemsScreen(
//                                                   existingId: carGarageItems
//                                                       .items[index].id)));
//                                 },
//                                 icon: Icon(
//                                   Icons.edit,
//                                   color: Theme.of(context).primaryColor,
//                                 )),
//                             IconButton(
//                                 onPressed: () async {
//                                   try {
//                                     await carGarageItems.deleteVehicle(
//                                         carGarageItems.items[index].id);
//                                     print('deleted');
//                                     Fluttertoast.showToast(
//                                         msg: 'Deleted Successfully!',
//                                         toastLength: Toast.LENGTH_SHORT,
//                                         gravity: ToastGravity.BOTTOM,
//                                         textColor: Colors.white,
//                                         fontSize: 12.0);
//                                   } catch (error) {
//                                     scaffold.showSnackBar(SnackBar(
//                                         content: Text(
//                                       'Deleting Failed!',
//                                       textAlign: TextAlign.center,
//                                     )));
//                                   }
//                                 },
//                                 icon: Icon(
//                                   Icons.delete,
//                                   color: Theme.of(context).errorColor,
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//               itemCount: carGarageItems.items.length,
//             ),
//           ),
//           IconButton(
//               onPressed: () {
//                 _refreshVehicles(context);
//               },
//               icon: Icon(Icons.refresh)),
//         ],
//       ),
//     );
//   }
// }
