import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';

class DistributorOrderDetailsPage extends StatefulWidget {
  static const String routeName = '/distributor_order_details';

  const DistributorOrderDetailsPage({Key? key}) : super(key: key);

  @override
  _DistributorOrderDetailsPageState createState() => _DistributorOrderDetailsPageState();
}

class _DistributorOrderDetailsPageState extends State<DistributorOrderDetailsPage> {
  String? orderId;
  late OrderProvider _orderProvider;
  @override
  void didChangeDependencies() {
    orderId = ModalRoute.of(context)!.settings.arguments as String;
    _orderProvider = Provider.of<OrderProvider>(context);
    _orderProvider.getDistributorOrderDetails(orderId!);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Details'),
      ),
      body: ListView.builder(
        itemCount: _orderProvider.distributorOrderDetailsList.length,
        itemBuilder: (context, index) {
          final details = _orderProvider.distributorOrderDetailsList[index];
          return Card(
            child: ListTile(
              title: Text(details.productName),
              trailing: Text('${details.qty}x${details.price}'),
            ),
          );
        },
      ),
    );
  }
}
