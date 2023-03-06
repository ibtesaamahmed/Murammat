import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:murammat_app/models/http_exception.dart';
import 'package:murammat_app/providers/auth.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

import '/screens/costumer/costumer_login_screen.dart';

class CostumerSignupScreen extends StatefulWidget {
  static const routeName = '/costumer-signup';

  @override
  State<CostumerSignupScreen> createState() => _CostumerSignupScreenState();
}

class _CostumerSignupScreenState extends State<CostumerSignupScreen> {
  var _isLoading = false;
  int currentStep = 0;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phoneNo = TextEditingController();
  final _houseNo = TextEditingController();
  final _streetNo = TextEditingController();
  final _areaOrSector = TextEditingController();
  final _city = TextEditingController();
  List<Step> steplist() => [
        Step(
            isActive: currentStep >= 0,
            title: const Icon(
              Icons.person,
              color: Color.fromRGBO(24, 45, 75, 1),
            ),
            content: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('Personal', style: TextStyle(fontSize: 20)),
                ),
                TextField(
                  controller: _firstName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'First Name'),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _lastName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Last Name'),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _phoneNo,
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
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('Address', style: TextStyle(fontSize: 20)),
                ),
                TextField(
                  controller: _houseNo,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'House No'),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _streetNo,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Street'),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _areaOrSector,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Area/Sector'),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _city,
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
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Text('Account', style: TextStyle(fontSize: 20)),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email'),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _confirmPassword,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password'),
              ),
            ],
          ),
        )
      ];

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                'An Error Occured',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: Text(
                message,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Costumer Sign up'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(
              child: CustomCircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: Stepper(
                    type: StepperType.horizontal,
                    currentStep: currentStep,
                    onStepContinue: (() async {
                      final isLastStep = currentStep == steplist().length - 1;

                      if (isLastStep) {
                        if (_passwordController.text != _confirmPassword.text) {
                          // Fluttertoast.showToast(
                          //   msg: 'Password did not match',
                          //   toastLength: Toast.LENGTH_SHORT,
                          //   gravity: ToastGravity.BOTTOM,
                          //   textColor: Colors.black,
                          //   backgroundColor: Theme.of(context).primaryColorLight,
                          //   fontSize: 12.0,
                          // );
                          _showErrorDialog('Password do not match');
                          return;
                        } else if (_firstName.text.isEmpty ||
                            _lastName.text.isEmpty ||
                            _phoneNo.text.isEmpty ||
                            _houseNo.text.isEmpty ||
                            _streetNo.text.isEmpty ||
                            _areaOrSector.text.isEmpty ||
                            _city.text.isEmpty) {
                          // Fluttertoast.showToast(
                          //   msg: 'Fill all fields please',
                          //   toastLength: Toast.LENGTH_LONG,
                          //   gravity: ToastGravity.BOTTOM,
                          //   textColor: Colors.black,
                          //   backgroundColor: Theme.of(context).primaryColorLight,
                          //   fontSize: 12.0,
                          // );
                          _showErrorDialog('Missing Fields');
                          return;
                        }
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          await Provider.of<Auth>(context, listen: false)
                              .signUp(
                            _emailController.text,
                            _passwordController.text,
                          );
                          Navigator.of(context).pushReplacementNamed(
                              CostumerLoginScreen.routeName);
                        } on HttpException catch (error) {
                          var errorMessage = 'Authentication failed!';
                          if (error.toString().contains('EMAIL_EXISTS')) {
                            errorMessage = 'This email already exists';
                          } else if (error
                              .toString()
                              .contains('INVALID_EMAIL')) {
                            errorMessage = 'This email is invalid';
                          } else if (error
                              .toString()
                              .contains('WEAK_PASSWORD')) {
                            errorMessage = 'This password is weak';
                          }
                          _showErrorDialog(errorMessage);
                        } catch (error) {
                          const errorMessage =
                              'Could not Autahenticate you, Please try again later!';
                          _showErrorDialog(errorMessage);
                        }
                        setState(() {
                          _isLoading = false;
                        });

                        //for sending data of textfields
                      } else {
                        setState(() {
                          currentStep += 1;
                        });
                      }
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
                        Navigator.of(context).pushReplacementNamed(
                            CostumerLoginScreen.routeName);
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
    );
  }
}
