import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:murammat_app/providers/my_garage.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class AddNewVehicle extends StatefulWidget {
  @override
  State<AddNewVehicle> createState() => _AddNewVehicleState();
}

class _AddNewVehicleState extends State<AddNewVehicle> {
  final _nameController = TextEditingController();
  final _milageController = TextEditingController();
  final _enginesizeController = TextEditingController();
  final _topspeedController = TextEditingController();
  File? file;
  DateTime? _selectedDate;
  var image;
  var _isLoading = false;

  _openGallery() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(image!.path);
    });
    print(file.toString());
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
    return Padding(
      padding: EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            autofocus: false,
            controller: _nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                labelText: 'Vehicle Name',
                labelStyle: TextStyle(
                    fontSize: 14, color: Theme.of(context).primaryColor)),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            autofocus: false,
            controller: _milageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              labelText: 'Mileage (Km)',
              labelStyle: TextStyle(
                  fontSize: 14, color: Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            autofocus: false,
            controller: _enginesizeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              labelText: 'Engine Size (cc)',
              labelStyle: TextStyle(
                  fontSize: 14, color: Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            autofocus: false,
            controller: _topspeedController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              labelText: 'Top Speed (Km/h)',
              labelStyle: TextStyle(
                  fontSize: 14, color: Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
                        child: Text(
                        'Insert Image',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      )),
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
              _isLoading == true
                  ? Center(child: CustomCircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () async {
                        final newVehicle;
                        if (_nameController.text.isEmpty ||
                            _selectedDate == null ||
                            file == null ||
                            _milageController.text.isEmpty ||
                            _enginesizeController.text.isEmpty ||
                            _topspeedController.text.isEmpty) {
                          return;
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                          newVehicle = GarageItems(
                            id: DateTime.now().toString(),
                            vehicleName: _nameController.text,
                            image: image,
                            dateTime: _selectedDate!,
                            milage: int.parse(_milageController.text),
                            engineSize: int.parse(_enginesizeController.text),
                            topSpeed: int.parse(_topspeedController.text),
                          );

                          await Provider.of<Garage>(context, listen: false)
                              .addNewVehicle(newVehicle);
                        }
                        Navigator.of(context).pop();
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Text('Submit')),
            ],
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
