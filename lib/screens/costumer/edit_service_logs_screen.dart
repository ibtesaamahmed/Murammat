import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:murammat_app/providers/my_garage.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class EditServiceLogScreen extends StatefulWidget {
  final String existingServiceId;
  final String existingVehicleId;

  EditServiceLogScreen(
      {required this.existingServiceId, required this.existingVehicleId});

  @override
  State<EditServiceLogScreen> createState() => _EditServiceLogScreenState();
}

class _EditServiceLogScreenState extends State<EditServiceLogScreen> {
  DateTime? _selectedDate;
  final _detailController = TextEditingController();
  final _priceController = TextEditingController();
  var _isLoading = false;
  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _sumitData() async {
    final newServiceLog;
    if (_detailController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedDate == null) {
      return;
    } else {
      setState(() {
        _isLoading = true;
      });
      newServiceLog = ServiceLogs(
        id: DateTime.now().toString(),
        totalPrice: int.parse(_priceController.text),
        serviceDetail: _detailController.text,
        dateTime: _selectedDate!,
      );
      await Provider.of<Garage>(context, listen: false).updateServiceLogs(
          widget.existingServiceId, widget.existingVehicleId, newServiceLog);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Edit Logs'),
        actions: <Widget>[
          IconButton(
            onPressed: _sumitData,
            icon: Icon(Icons.done),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CustomCircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(children: <Widget>[
                TextField(
                  autofocus: false,
                  maxLines: 4,
                  controller: _detailController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    labelText: 'Service Details',
                    labelStyle: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          "Price (Rs)",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14),
                        ),
                      ),
                      Container(
                        width: 70,
                        child: TextField(
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          controller: _priceController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            labelStyle: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          _selectedDate == null
                              ? 'No Date Choosen'
                              : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14),
                        ),
                      ),
                      TextButton(
                          onPressed: _showDatePicker,
                          child: Text(
                            'Choose Date',
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _sumitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ]),
            ),
    );
  }
}
