import 'package:ecommerce_own_user_app/models/distributor_cart_model.dart';
import 'package:ecommerce_own_user_app/models/product_model.dart';
import 'package:ecommerce_own_user_app/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';
import 'checkout_page.dart';

class DistributorCartPage extends StatefulWidget {
  static const String routeName = '/distributor_cart_page';

  @override
  _DistributorCartPageState createState() => _DistributorCartPageState();
}

class _DistributorCartPageState extends State<DistributorCartPage> {
  late CartProvider _cartProvider;

  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getAllDistributorCartItems();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('My Cart'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(primary: Colors.white),
            child: Text('CLEAR'),
            onPressed: () {
              _cartProvider.clearCart();
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartProvider.distributorcartList.length,
              itemBuilder: (context, index) {
                final model = _cartProvider.distributorcartList[index];
                return ListTile(
                  title: Text(model.productName),
                  subtitle: Text('$takaSymbol${model.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 12,
                          child: Text(
                            "-16",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () {
                          _cartProvider.decreaseDistributorQty16(model);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          _cartProvider.decreaseDistributorQty(model);
                        },
                      ),
                      Text('${model.qty}'),
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () {
                          _cartProvider.increaseDistributorQty(model);
                        },
                      ),
                      IconButton(
                        icon: CircleAvatar(
                          backgroundColor: Colors.greenAccent,
                          radius: 12,
                          child: Text(
                            "+16",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () {
                          _cartProvider.increaseDistributorQty16(model);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          _cartProvider.removeFromCart(model.productId);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: $takaSymbol${_cartProvider.cartItemsTotalPrice}',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  TextButton(
                    child: const Text('Checkout'),
                    onPressed: _cartProvider.totalItemsInCart == 0
                        ? null
                        : () {
                            Navigator.pushNamed(
                                context, CheckoutPage.routeName);
                          },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
