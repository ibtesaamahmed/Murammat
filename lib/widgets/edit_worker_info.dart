import 'package:flutter/material.dart';

import 'package:murammat_app/providers/auth.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class EditWorkerInfo extends StatefulWidget {
  const EditWorkerInfo({super.key});

  @override
  State<EditWorkerInfo> createState() => _EditWorkerInfoState();
}

class _EditWorkerInfoState extends State<EditWorkerInfo> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNoController = TextEditingController();
  var _isLoading = false;
  WorkerInfo? wi;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => _getText());
    super.initState();
  }

  Future<void> _getText() async {
    final userData = Provider.of<Auth>(context, listen: false);
    _firstNameController.text = userData.workerInfo.firstName;
    _lastNameController.text = userData.workerInfo.lastName;
    _phoneNoController.text = userData.workerInfo.phoneNo;
    wi = userData.workerInfo;
  }

  _submitData() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _phoneNoController.text.isEmpty) {
      _showErrorDialog('Missing Fields');
      return;
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false).editWorkerInfo(
            wi!.id,
            _firstNameController.text,
            _lastNameController.text,
            _phoneNoController.text);
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
