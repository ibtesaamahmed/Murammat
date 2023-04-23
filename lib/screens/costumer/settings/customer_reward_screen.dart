import 'package:flutter/material.dart';

class CustomerRewardScreen extends StatelessWidget {
  const CustomerRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rewards')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: Image.asset("assets/images/waiting.png"),
              height: 50,
            ),
            const SizedBox(height: 20),
            Text(
              'You do not have any rewards yet!',
              style: TextStyle(color: Theme.of(context).primaryColor),
            )
          ],
        ),
      ),
    );
  }
}
