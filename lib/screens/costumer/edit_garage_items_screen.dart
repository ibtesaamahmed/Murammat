import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/my_garage.dart';

class EditGarageItemsScreen extends StatefulWidget {
  final String existingId;

  EditGarageItemsScreen({required this.existingId});

  @override
  State<EditGarageItemsScreen> createState() => _EditGarageItemsScreenState();
}

class _EditGarageItemsScreenState extends State<EditGarageItemsScreen> {
  DateTime? _selectedDate;
  final _nameController = TextEditingController();
  File? file;
  var image;

  _openGallery() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(image!.path);
    });
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Vehicle'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.done),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  labelText: 'Vehicle Name',
                  focusColor: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 8, right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: file != null
                      ? Image.file(file as File)
                      : Center(
                          child: Text('Update Image',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                ),
                ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor)),
                    onPressed: _openGallery,
                    icon: Icon(Icons.browse_gallery),
                    label: Text('Choose from Gallery'))
              ],
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Choosen'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  TextButton(
                      onPressed: _showDatePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    final newVehicle;
                    if (_nameController.text.isEmpty ||
                        _selectedDate == null ||
                        file == null) {
                      return;
                    } else {
                      newVehicle = GarageItems(
                          id: DateTime.now().toString(),
                          vehicleName: _nameController.text,
                          image: image,
                          dateTime: _selectedDate!);
                      Provider.of<Garage>(context, listen: false)
                          .updateVehicle(newVehicle, widget.existingId);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text('Submit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
