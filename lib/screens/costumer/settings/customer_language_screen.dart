import 'package:flutter/material.dart';

class CustomerLanguageScreen extends StatefulWidget {
  @override
  State<CustomerLanguageScreen> createState() => _CustomerLanguageScreenState();
}

class _CustomerLanguageScreenState extends State<CustomerLanguageScreen> {
  bool? eng = false;

  bool? urdu = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Languages'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            CheckboxListTile(
              value: eng,
              onChanged: ((val) {
                setState(() {
                  eng = val;
                });
              }),
              activeColor: Theme.of(context).primaryColor,
              title: Text('English'),
            ),
            CheckboxListTile(
              value: urdu,
              onChanged: ((val) {
                setState(() {
                  urdu = val;
                });
              }),
              activeColor: Theme.of(context).primaryColor,
              title: Text('Urdu'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Done'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
