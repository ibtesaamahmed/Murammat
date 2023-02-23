import 'package:flutter/material.dart';

class ShopsCustomerScreen extends StatelessWidget {
  static const routeName = '/shops-customers';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Shops')),
    );
  }
}
