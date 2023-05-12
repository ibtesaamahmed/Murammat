import 'package:flutter/material.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';
import '../../providers/auth.dart';
import '/screens/worker/worker_tab_screen.dart';
import '/screens/worker/worker_signup_screen.dart';

class WorkerLoginScreen extends StatefulWidget {
  static const routeName = '/worker-login';

  @override
  State<WorkerLoginScreen> createState() => _WorkerLoginScreenState();
}

class _WorkerLoginScreenState extends State<WorkerLoginScreen> {
  var _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  void _showErrorDialog(String message, BuildContext context) {
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
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
                  controller: _emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Username'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Password'),
                ),
                const SizedBox(
                  height: 30,
                ),
                _isLoading
                    ? Center(
                        child: CustomCircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            _showErrorDialog('Missing Fields', context);
                            return;
                          }
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await Provider.of<Auth>(context, listen: false)
                                .login(_emailController.text,
                                    _passwordController.text, 'workers');
                            Navigator.of(context).pushReplacementNamed(
                                WorkerTabScreen.routeName);
                          } on HttpException catch (error) {
                            var errorMessage = 'Authentication failed!';
                            if (error.toString().contains('INVALID_EMAIL')) {
                              errorMessage = 'This email is invalid';
                            } else if (error
                                .toString()
                                .contains('EMAIL_NOT_FOUND')) {
                              errorMessage = 'This email not found';
                            } else if (error
                                .toString()
                                .contains('INVALID_PASSWORD')) {
                              errorMessage = 'You entered invalid password';
                            }
                            _showErrorDialog(errorMessage, context);
                          } catch (error) {
                            const errorMessage =
                                'Could not Autahenticate you, Please try again later!';
                            _showErrorDialog(errorMessage, context);
                          }

                          setState(() {
                            _isLoading = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 5,
                            fixedSize: const Size(120, 40),
                            backgroundColor:
                                Theme.of(context).appBarTheme.backgroundColor,
                            foregroundColor: Colors.white),
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
                        Navigator.of(context)
                            .pushReplacementNamed(WorkerSignupScreen.routeName);
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
