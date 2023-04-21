import 'package:flutter/material.dart';

class CustomerPersonalInfo extends StatelessWidget {
  const CustomerPersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Information')),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person_pin),
            title: Text(
              'Name',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
            trailing: IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {},
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(
              'Phone Number',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
            trailing: IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {},
            ),
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text(
              'Email',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
            trailing: IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {},
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text(
              'Change Password',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
            trailing: IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {},
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Gender',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
            trailing: IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {},
            ),
          ),
        ],
      )),
    );
  }
}
