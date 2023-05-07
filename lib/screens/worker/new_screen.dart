import 'package:flutter/material.dart';
import 'package:murammat_app/providers/worker_location.dart';
import 'package:provider/provider.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sami'),
      ),
      body: Consumer<WorkerShopLocation>(
        builder: (context, provider, _) {
          final pro = provider.listenToCustomerRequest();
          if (provider.requestsList.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: provider.requestsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(provider.requestsList[index].customerId),
                  subtitle: Text(provider.requestsList[index].lat +
                      provider.requestsList[index].long),
                );
              },
            );
          }
        },
      ),
    );
  }
}
