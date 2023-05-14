import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class WorkerAboutUs extends StatelessWidget {
  const WorkerAboutUs({super.key});

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
