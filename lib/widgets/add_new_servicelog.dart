import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:murammat_app/providers/my_garage.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class AddNewServiceLog extends StatefulWidget {
  final String existingId;
  AddNewServiceLog(this.existingId);
  @override
  State<AddNewServiceLog> createState() => _AddNewServiceLogState();
}

class _AddNewServiceLogState extends State<AddNewServiceLog> {
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

  @override
  Widget build(BuildContext context) {
    return _isLoading == true
        ? Center(
            child: CustomCircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                      onPressed: () async {
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
                              totalPrice: int.parse(_priceController.text),
                              serviceDetail: _detailController.text,
                              dateTime: _selectedDate!);
                          await Provider.of<Garage>(context, listen: false)
                              .addServiceLog(newServiceLog, widget.existingId);
                        }
                        Navigator.of(context).pop();
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text('Submit'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
  }
}
