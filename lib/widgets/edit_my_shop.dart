import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:murammat_app/providers/auth.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class EditMyShop extends StatefulWidget {
  const EditMyShop({super.key});

  @override
  State<EditMyShop> createState() => _EditMyShopState();
}

class _EditMyShopState extends State<EditMyShop> {
  final _shopNoController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _areaOrSectorController = TextEditingController();
  final _streetNoController = TextEditingController();
  final _cityController = TextEditingController();
  var _isLoading = false;
  WorkerInfo? wi;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => _getText());
    super.initState();
  }

  Future<void> _getText() async {
    final userData = Provider.of<Auth>(context, listen: false);
    _shopNoController.text = userData.workerInfo.shopNo;
    _shopNameController.text = userData.workerInfo.shopName;
    _areaOrSectorController.text = userData.workerInfo.areaOrSector;
    _cityController.text = userData.workerInfo.city;
    _streetNoController.text = userData.workerInfo.streetNo;
    wi = userData.workerInfo;
  }

  _submitData() async {
    if (_shopNameController.text.isEmpty ||
        _shopNoController.text.isEmpty ||
        _areaOrSectorController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _streetNoController.text.isEmpty) {
      _showErrorDialog('Missing Fields');
      return;
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false).editMyShop(
            wi!.id,
            _shopNameController.text,
            _shopNoController.text,
            _areaOrSectorController.text,
            _streetNoController.text,
            _cityController.text);
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
              controller: _shopNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Shop Name',
                  labelStyle: TextStyle(
                      fontSize: 14, color: Theme.of(context).primaryColor)),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              autofocus: false,
              controller: _shopNoController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Shop No',
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
          ],
        ),
      ),
    );
  }
}
