import 'package:ecommerce_own_user_app/models/product_model.dart';
import 'package:ecommerce_own_user_app/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart_page';

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartProvider _cartProvider;

  @override
  void didChangeDependencies() {
    _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getAllCartItems();
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
              itemCount: _cartProvider.cartList.length,
              itemBuilder: (context, index) {
                final model = _cartProvider.cartList[index];
                return ListTile(
                  title: Text(model.productName),
                  subtitle: Text('$takaSymbol${model.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          _cartProvider.decreaseQty(model);
                        },
                      ),
                      Text('${model.qty}'),
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () {
                          _cartProvider.increaseQty(model);
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
