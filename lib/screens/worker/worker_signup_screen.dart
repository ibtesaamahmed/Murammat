import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:murammat_app/providers/auth.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';
import '/screens/worker/worker_login_screen.dart';

class WorkerSignupScreen extends StatefulWidget {
  static const routeName = '/worker-signup';

  @override
  State<WorkerSignupScreen> createState() => _WorkerSignupScreenState();
}

class _WorkerSignupScreenState extends State<WorkerSignupScreen> {
  int currentStep = 0;
  var _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phoneNo = TextEditingController();
  final _shopNo = TextEditingController();
  final _shopName = TextEditingController();
  final _streetNo = TextEditingController();
  final _areaOrSector = TextEditingController();
  final _city = TextEditingController();
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassword.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _phoneNo.dispose();
    _shopNo.dispose();
    _shopName.dispose();
    _streetNo.dispose();
    _areaOrSector.dispose();
    _city.dispose();
    super.dispose();
  }

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
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _lastName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Last Name'),
                ),
                const SizedBox(
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
                  controller: _shopNo,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Shop No'),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _shopName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Shop Name'),
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
                child: Text('Personal', style: TextStyle(fontSize: 20)),
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
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                obscureText: true,
                controller: _confirmPassword,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password'),
              ),
            ],
          ),
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Sign up'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading == true
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
                          _showErrorDialog('Password do not match');

                          return;
                        } else if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty ||
                            _firstName.text.isEmpty ||
                            _lastName.text.isEmpty ||
                            _phoneNo.text.isEmpty ||
                            _shopNo.text.isEmpty ||
                            _shopName.text.isEmpty ||
                            _streetNo.text.isEmpty ||
                            _areaOrSector.text.isEmpty ||
                            _city.text.isEmpty) {
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
                                  'workers',
                                  _firstName.text,
                                  _lastName.text,
                                  _phoneNo.text,
                                  _shopNo.text,
                                  _streetNo.text,
                                  _areaOrSector.text,
                                  _city.text,
                                  '',
                                  _shopName.text);
                          Navigator.of(context).pushReplacementNamed(
                              WorkerLoginScreen.routeName);
                          Fluttertoast.showToast(
                              msg: 'Registered Successfully!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              textColor: Colors.white,
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8),
                              fontSize: 12.0);
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
                        Navigator.of(context)
                            .pushReplacementNamed(WorkerLoginScreen.routeName);
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
