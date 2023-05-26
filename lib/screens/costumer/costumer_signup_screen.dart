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
  final _gender = TextEditingController();
  final _phoneNo = TextEditingController();
  final _cnic = TextEditingController();
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
                  padding: EdgeInsets.all(5),
                  child: Text('Personal', style: TextStyle(fontSize: 20)),
                ),
                // Column(
                //   children: [
                //     // CircleAvatar(
                //     //   radius: 30,
                //     //   backgroundColor: Theme.of(context).canvasColor,
                //     //   backgroundImage:
                //     //       Image.asset('assets/images/placeholder.png').image,
                //     // ),
                //     Container(
                //       width: 70.0,
                //       height: 70.0,
                //       decoration: BoxDecoration(
                //         color: Theme.of(context).canvasColor,
                //         image: DecorationImage(
                //           image: AssetImage('assets/images/placeholder.png'),
                //           fit: BoxFit.cover,
                //         ),
                //         borderRadius: BorderRadius.all(Radius.circular(50.0)),
                //         border: Border.all(
                //           color: Theme.of(context).primaryColor,
                //           width: 4.0,
                //         ),
                //       ),
                //     ),
                //     IconButton(
                //         onPressed: () {},
                //         icon: Icon(
                //           Icons.add_a_photo,
                //           color: Theme.of(context).primaryColor,
                //         ))
                //   ],
                // ),
                SizedBox(
                  height: 5,
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
                  controller: _gender,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Gender'),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _phoneNo,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Phone No'),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _cnic,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'CNIC'),
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
                          _showErrorDialog('Password do not match');
                          return;
                        } else if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty ||
                            _firstName.text.isEmpty ||
                            _lastName.text.isEmpty ||
                            _phoneNo.text.isEmpty ||
                            _houseNo.text.isEmpty ||
                            _streetNo.text.isEmpty ||
                            _areaOrSector.text.isEmpty ||
                            _city.text.isEmpty ||
                            _gender.text.isEmpty) {
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
                            'customers',
                            _firstName.text,
                            _lastName.text,
                            _phoneNo.text,
                            _houseNo.text,
                            _streetNo.text,
                            _areaOrSector.text,
                            _city.text,
                            _gender.text,
                          );
                          Navigator.of(context).pushReplacementNamed(
                              CostumerLoginScreen.routeName);
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
