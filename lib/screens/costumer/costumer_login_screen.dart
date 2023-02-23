import 'package:flutter/material.dart';

import '/screens/costumer/costumer_tab_screen.dart';
import '/screens/costumer/costumer_signup_screen.dart';

class CostumerLoginScreen extends StatelessWidget {
  static const routeName = '/costumer-login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Costumer Login'),
      ),
      body: Container(
        height: double.infinity,
        color: Color.fromRGBO(206, 206, 206, 1),
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/logo.png",
                  width: double.infinity,
                  height: 250,
                ),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Username'),
                ),
                const SizedBox(
                  height: 5,
                ),
                const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Password'),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(CostumerTabScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      fixedSize: const Size(120, 40),
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor,
                      foregroundColor: Theme.of(context).accentColor),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Don\'t have an Account?',
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                            CostumerSignupScreen.routeName);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
