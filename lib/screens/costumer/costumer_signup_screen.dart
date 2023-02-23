import 'package:flutter/material.dart';

import '/screens/costumer/costumer_login_screen.dart';

class CostumerSignupScreen extends StatefulWidget {
  static const routeName = '/costumer-signup';

  @override
  State<CostumerSignupScreen> createState() => _CostumerSignupScreenState();
}

class _CostumerSignupScreenState extends State<CostumerSignupScreen> {
  int currentStep = 0;
  List<Step> steplist() => [
        Step(
            isActive: currentStep >= 0,
            title: const Icon(
              Icons.person,
              color: Color.fromRGBO(24, 45, 75, 1),
            ),
            content: Column(
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('Personal', style: TextStyle(fontSize: 20)),
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'First Name'),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Last Name'),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Phone No'),
                ),
              ],
            )),
        Step(
            isActive: currentStep >= 1,
            title: const Icon(
              Icons.home,
              color: Color.fromRGBO(24, 45, 75, 1),
            ),
            content: Column(
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('Address', style: TextStyle(fontSize: 20)),
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'House No'),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Street'),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Area/Sector'),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'City'),
                ),
              ],
            )),
        Step(
          isActive: currentStep >= 2,
          title: const Icon(
            Icons.key,
            color: Color.fromRGBO(24, 45, 75, 1),
          ),
          content: Column(
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Text('Account', style: TextStyle(fontSize: 20)),
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email'),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password'),
              ),
            ],
          ),
        )
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Costumer Sign up'),
        automaticallyImplyLeading: false,
      ),
      body: Theme(
        data: ThemeData(
            canvasColor: const Color.fromRGBO(206, 206, 206, 1),
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color.fromRGBO(24, 45, 75, 1),
                  secondary: Colors.green,
                )),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: currentStep,
                onStepContinue: (() {
                  setState(() {
                    final isLastStep = currentStep == steplist().length - 1;
                    if (isLastStep) {
                      Navigator.of(context)
                          .pushReplacementNamed(CostumerLoginScreen.routeName);
                      //for sending data of textfields
                    } else {
                      currentStep += 1;
                    }
                  });
                }),
                onStepTapped: (index) {
                  setState(() {
                    currentStep = index;
                  });
                },
                onStepCancel: () {
                  if (currentStep == 0) {
                    return;
                  }
                  setState(() {
                    currentStep -= 1;
                  });
                },
                steps: steplist(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Already have an Account?',
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(CostumerLoginScreen.routeName);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
