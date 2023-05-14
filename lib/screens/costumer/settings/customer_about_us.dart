import 'package:flutter/material.dart';

class CustomerAboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Center(
            child: Container(
              height: 200,
              child: Image.asset(
                'assets/images/logo.png',
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
