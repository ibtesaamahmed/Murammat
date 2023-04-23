import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:murammat_app/providers/auth.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class CustomerRateScreen extends StatefulWidget {
  @override
  State<CustomerRateScreen> createState() => _CustomerRateScreenState();
}

class _CustomerRateScreenState extends State<CustomerRateScreen> {
  var _isLoading = false;
  double? _ratingValue;
  final _reviewController = TextEditingController();
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
    return Scaffold(
      appBar: AppBar(title: Text('Rating and Review')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Rate our App!',
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: RatingBar(
                    initialRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.orange),
                        half: const Icon(
                          Icons.star_half,
                          color: Colors.orange,
                        ),
                        empty: const Icon(
                          Icons.star_outline,
                          color: Colors.orange,
                        )),
                    onRatingUpdate: (value) {
                      setState(() {
                        _ratingValue = value;
                      });
                    }),
              ),
              const SizedBox(height: 25),
              Center(
                child: Text(
                  _ratingValue != null ? _ratingValue.toString() : '0',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Write a Review',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
              ),
              const SizedBox(height: 10),
              TextField(
                maxLines: 5,
                controller: _reviewController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: _isLoading
                        ? Center(
                            child: CustomCircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              try {
                                setState(() {
                                  _isLoading = true;
                                });
                                await Provider.of<Auth>(context, listen: false)
                                    .postRatingsAndReviews(
                                        _ratingValue!, _reviewController.text);
                                setState(() {
                                  _isLoading = false;
                                  _reviewController.text = '';
                                });
                                _showErrorDialog('Sent Successfully', 'Thanks');
                              } catch (error) {
                                setState(() {
                                  _isLoading = false;
                                });
                                _showErrorDialog('Error', 'An Error Occured');
                                throw error;
                              }
                            },
                            child: Text('Submit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
