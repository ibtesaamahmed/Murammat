import 'package:flutter/material.dart';

class AtDoorStepServicesScreen extends StatefulWidget {
  static const routeName = '/at-doorstep-services';

  @override
  State<AtDoorStepServicesScreen> createState() =>
      _AtDoorStepServicesScreenState();
}

class _AtDoorStepServicesScreenState extends State<AtDoorStepServicesScreen> {
  bool? AtDoorWash = false;
  bool? AtDoorEngineReplacement = false;
  bool? AtDoorEngineRepair = false;
  bool? AtDoorOilChangeOrFilter = false;
  bool? AtDoorAccidentRecovery = false;
  String otherServicesAtDoor = '';
  late TextEditingController controller;
  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<String?> openOthersDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Others'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter other services',
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(controller.text);
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doorstep Services')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                'Choose At DoorStep Services you want!',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CheckboxListTile(
              value: AtDoorWash,
              onChanged: ((val) {
                setState(() {
                  AtDoorWash = val;
                });
              }),
              activeColor: Theme.of(context).primaryColor,
              title: Text(' Wash'),
            ),
            CheckboxListTile(
              value: AtDoorEngineReplacement,
              onChanged: ((val) {
                setState(() {
                  AtDoorEngineReplacement = val;
                });
              }),
              activeColor: Theme.of(context).primaryColor,
              title: Text('Engine Replacement'),
            ),
            CheckboxListTile(
              value: AtDoorEngineRepair,
              onChanged: ((val) {
                setState(() {
                  AtDoorEngineRepair = val;
                });
              }),
              activeColor: Theme.of(context).primaryColor,
              title: Text('Engine Repair'),
            ),
            CheckboxListTile(
              value: AtDoorOilChangeOrFilter,
              onChanged: ((val) {
                setState(() {
                  AtDoorOilChangeOrFilter = val;
                });
              }),
              activeColor: Theme.of(context).primaryColor,
              title: Text('Oil change or Filter'),
            ),
            CheckboxListTile(
              value: AtDoorAccidentRecovery,
              onChanged: ((val) {
                setState(() {
                  AtDoorAccidentRecovery = val;
                });
              }),
              activeColor: Theme.of(context).primaryColor,
              title: Text('Accident Recovery'),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    final val = await openOthersDialog();
                    if (val == null || val.isEmpty) return;
                    setState(() {
                      otherServicesAtDoor = val;
                    });
                  },
                  child: Text('Others'),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(100, 40),
                      backgroundColor: Theme.of(context).primaryColor),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Done'),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(100, 40),
                      backgroundColor: Theme.of(context).primaryColor),
                ),
              ],
            ),
            Text(otherServicesAtDoor),
          ],
        ),
      ),
    );
  }
}
