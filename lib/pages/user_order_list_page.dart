import 'package:ecommerce_own_user_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../providers/order_provider.dart';
import '../utils/helper_functions.dart';
import 'order_details_page.dart';

class UserOrderListPage extends StatefulWidget {
  static const String routeName = '/user_orders';

  const UserOrderListPage({Key? key}) : super(key: key);

  @override
  _UserOrderListPageState createState() => _UserOrderListPageState();
}

class _UserOrderListPageState extends State<UserOrderListPage> {
  late OrderProvider _orderProvider;

  @override
  void didChangeDependencies() {
    _orderProvider = Provider.of<OrderProvider>(context);
    _orderProvider.getUserOrders(AuthService.currentUser!.uid);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('My Orders'),
      ),
      body: ListView.builder(
        itemCount: _orderProvider.userOrderList.length,
        itemBuilder: (context, index) {
          final order = _orderProvider.userOrderList[index];
          return Card(
            child: ListTile(
              onTap: () => Navigator.pushNamed(
                  context, OrderDetailsPage.routeName,
                  arguments: order.orderId),
              title: Text(getFormattedDate(
                  order.timestamp.millisecondsSinceEpoch,
                  'dd/MM/yyyy hh:mm a')),
              subtitle: Text(
                order.orderStatus,
                style: TextStyle(color: Colors.green),
              ),
              trailing: Text(
                '$takaSymbol${order.grandTotal}',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}