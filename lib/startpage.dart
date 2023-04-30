import 'package:flutter/material.dart';

import '/screens/costumer/costumer_login_screen.dart';
import '/screens/worker/worker_login_screen.dart';

class StartPage extends StatelessWidget {
  static const routeName = '/startpage';

  Widget button(Text text, VoidCallback pressed, context) {
    return ElevatedButton(
      onPressed: pressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        fixedSize: const Size(150, 50),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(20, 30)),
        ),
      ),
      child: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text('MURAMMAT'),
      // ),
      body: Container(
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/logo.png"),
                fit: BoxFit.scaleDown),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      button(
                        const Text(
                          'I am a Costumer',
                          style: TextStyle(fontSize: 16),
                        ),
                        () {
                          Navigator.of(context)
                              .pushNamed(CostumerLoginScreen.routeName);
                        },
                        context,
                      ),
                      button(
                        const Text(
                          'I am a Worker',
                          style: TextStyle(fontSize: 16),
                        ),
                        () {
                          Navigator.of(context)
                              .pushNamed(WorkerLoginScreen.routeName);
                        },
                        context,
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
