import 'package:flutter/material.dart';
import 'package:murammat_app/providers/auth.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class EditCustomerInfo extends StatefulWidget {
  const EditCustomerInfo({super.key});

  @override
  State<EditCustomerInfo> createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditCustomerInfo> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();
  final _areaOrSectorController = TextEditingController();
  final _houseNoController = TextEditingController();
  final _streetNoController = TextEditingController();
  final _cityController = TextEditingController();
  var _isLoading = false;
  CustomerInfo? ci;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => _getText());
    super.initState();
  }

  Future<void> _getText() async {
    final userData = Provider.of<Auth>(context, listen: false);
    _firstNameController.text = userData.customerInfo.firstName;
    _lastNameController.text = userData.customerInfo.lastName;
    _phoneNoController.text = userData.customerInfo.phoneNo;
    _emailController.text = userData.customerInfo.email;
    _genderController.text = userData.customerInfo.gender;
    _areaOrSectorController.text = userData.customerInfo.areaOrSector;
    _houseNoController.text = userData.customerInfo.houseNo;
    _streetNoController.text = userData.customerInfo.streetNo;
    _cityController.text = userData.customerInfo.city;
    ci = userData.customerInfo;
  }

  _submitData() async {
    final newUser;
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneNoController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _areaOrSectorController.text.isEmpty ||
        _houseNoController.text.isEmpty ||
        _streetNoController.text.isEmpty ||
        _cityController.text.isEmpty) {
      _showErrorDialog('Missing Fields');
      return;
    } else {
      setState(() {
        _isLoading = true;
      });
      newUser = CustomerInfo(
          id: ci!.id,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: ci!.email,
          phoneNo: _phoneNoController.text,
          gender: _genderController.text,
          areaOrSector: _areaOrSectorController.text,
          city: _cityController.text,
          houseNo: _houseNoController.text,
          streetNo: _streetNoController.text);
      try {
        await Provider.of<Auth>(context, listen: false)
            .editCustomerInfo(ci!.id, newUser);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } catch (error) {
        _showErrorDialog('An error Occured');
        setState(() {
          _isLoading = false;
        });
        throw error;
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                'An Error Occured',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: Text(
                message,
                style: const TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    // final userData = Provider.of<Auth>(context, listen: false);

    return SingleChildScrollView(
      child: Padding(
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
                controller: _firstNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'First Name',
                    labelStyle: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: false,
                controller: _lastNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Last Name',
                    labelStyle: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: false,
                controller: _phoneNoController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Phone No',
                    labelStyle: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: false,
                controller: _genderController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Gender',
                    labelStyle: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: false,
                controller: _areaOrSectorController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Area or Sector',
                    labelStyle: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: false,
                controller: _houseNoController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'House No',
                    labelStyle: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: false,
                controller: _streetNoController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Street No',
                    labelStyle: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: false,
                controller: _cityController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'City',
                    labelStyle: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor)),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _isLoading
                      ? CustomCircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submitData,
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ]),
      ),
    );
  }
}
