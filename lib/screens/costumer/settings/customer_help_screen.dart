import 'package:flutter/material.dart';
import 'package:murammat_app/providers/auth.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class CustomerHelpScreen extends StatefulWidget {
  @override
  State<CustomerHelpScreen> createState() => _CustomerHelpScreenState();
}

class _CustomerHelpScreenState extends State<CustomerHelpScreen> {
  var _isLoading = false;
  final _messageController = TextEditingController();
  void _showErrorDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                title,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              content: Text(
                message,
                style: const TextStyle(color: Colors.black),
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
    print('build');
    return Scaffold(
      appBar: AppBar(title: Text('Help')),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                'Ask Us',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              maxLines: 10,
              controller: _messageController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _isLoading
                      ? CustomCircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_messageController.text.isEmpty) {
                              _showErrorDialog(
                                  'An Error Occured', 'Empty Field');
                              return;
                            }
                            try {
                              setState(() {
                                _isLoading = true;
                              });
                              await Provider.of<Auth>(context, listen: false)
                                  .postHelpMessage(_messageController.text);
                              setState(() {
                                _isLoading = false;
                                _messageController.text = '';
                              });
                              _showErrorDialog('We got your back',
                                  'We have recieved your message, Our team will get back to you soon!');
                            } catch (error) {
                              setState(() {
                                _isLoading = false;
                              });
                              _showErrorDialog('Error', 'An Error Occured!');
                              throw error;
                            }
                          },
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
