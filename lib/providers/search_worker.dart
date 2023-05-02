import 'package:flutter/cupertino.dart';

class SearchWorker with ChangeNotifier {
  final authToken;
  final userId;
  SearchWorker(this.authToken, this.userId);
  Future<void> sendRequest() async {}
}
