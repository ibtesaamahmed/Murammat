import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  static const routeName = '/services';

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool? Towing = false;
  bool? EngineReplacement = false;
  bool? EngineRepair = false;
  bool? OilChangeOrFilter = false;
  bool? AccidentRecovery = false;
  String otherServices = '';
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
      appBar: AppBar(
        title: Text("Services"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                'Choose Services you want!',
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
              value: Towing,
              onChanged: ((val) {
                setState(() {
                  Towing = val;
                });
              }),
              activeColor: Theme.of(context).primaryColor,
              title: Text('Towing'),
            ),
            CheckboxListTile(
              value: EngineReplacement,
              onChanged: ((val) {
                setState(() {
                  EngineReplacement = val;
                });
              }),
              activeColor: Theme.of(context).primaryColor,
              title: Text('Engine Replacement'),
            ),
            CheckboxListTile(
              value: EngineRepair,
              onChanged: ((val) {
                setState(() {
                  EngineRepair = val;
                });
              }),
              activeColor: Theme.of(context).primaryColor,
              title: Text('Engine Repair'),
            ),
            CheckboxListTile(
              value: OilChangeOrFilter,
              onChanged: ((val) {
                setState(() {
                  OilChangeOrFilter = val;
                });
              }),
              activeColor: Theme.of(context).primaryColor,
              title: Text('Oil change or Filter'),
            ),
            CheckboxListTile(
              value: AccidentRecovery,
              onChanged: ((val) {
                setState(() {
                  AccidentRecovery = val;
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
                      otherServices = val;
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
            Text(otherServices),
          ],
        ),
      ),
    );
  }
}
