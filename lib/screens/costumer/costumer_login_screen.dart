import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:murammat_app/models/http_exception.dart';
import 'package:murammat_app/providers/auth.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

import '/screens/costumer/costumer_tab_screen.dart';
import '/screens/costumer/costumer_signup_screen.dart';

class CostumerLoginScreen extends StatefulWidget {
  static const routeName = '/costumer-login';

  @override
  State<CostumerLoginScreen> createState() => _CostumerLoginScreenState();
}

class _CostumerLoginScreenState extends State<CostumerLoginScreen> {
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
        title: const Text('Costumer Login'),
      ),
      body: Container(
        height: double.infinity,
        color: Color.fromRGBO(206, 206, 206, 1),
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
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
                  border: OutlineInputBorder(), labelText: 'Email'),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: _passwordController,
              keyboardType: TextInputType.number,
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
                        await Provider.of<Auth>(context, listen: false).login(
                            _emailController.text,
                            _passwordController.text,
                            'customers');
                        Navigator.of(context)
                            .pushReplacementNamed(CostumerTabScreen.routeName);
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
                        .pushReplacementNamed(CostumerSignupScreen.routeName);
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
