import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:murammat_app/providers/worker.dart';
import 'package:murammat_app/widgets/custom_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class WorkerReachedScreen extends StatefulWidget {
  int index;
  Position? initialPosition;
  WorkerReachedScreen(this.index, this.initialPosition);

  @override
  State<WorkerReachedScreen> createState() => _WorkerReachedScreenState();
}

class _WorkerReachedScreenState extends State<WorkerReachedScreen> {
  final _descriptionController = TextEditingController();

  final _priceController = TextEditingController();
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work Details'),
      ),
      body: _isLoading
          ? CustomCircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            "Price (Rs)",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: TextField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: _submitData, child: Text('End Work'))
                  ]),
            ),
    );
  }

  void _submitData() async {
    final initialPos = widget.initialPosition;
    if (_descriptionController.text.isEmpty || _priceController.text.isEmpty) {
      _showErrorDialog('Empty Fields');
      return;
    }
    final data = Provider.of<Worker>(context, listen: false);
    final customerLat = data.requestsList[widget.index].lat;
    final customerLong = data.requestsList[widget.index].long;
    setState(() {
      _isLoading = true;
    });
    double distanceBtw = await Geolocator.distanceBetween(
        initialPos!.latitude,
        initialPos.longitude,
        double.parse(customerLat),
        double.parse(customerLong));
    distanceBtw = distanceBtw / 1000;
    await data.addHistory(widget.index, _descriptionController.text,
        _priceController.text, distanceBtw);
    setState(() {
      _isLoading = true;
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
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
}
