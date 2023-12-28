import 'package:ecommerce_own_user_app/auth/auth_service.dart';
import 'package:ecommerce_own_user_app/db/db_helper.dart';
import 'package:ecommerce_own_user_app/models/distributor_cart_model.dart';
import 'package:flutter/foundation.dart';

import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartList = [];
  List<DistributorCartModel> distributorcartList = [];
  bool _isLoading = false;
  bool _isLoadingaddcart = false;

  bool get isLoading => _isLoading;
  bool get isLoadingaddcart => _isLoadingaddcart;
  void addToCart(ProductModel productModel) async {
    try {
      _isLoadingaddcart = true; // Set loading state to true
      notifyListeners();
      final cartModel = CartModel(
          productId: productModel.id!,
          productName: productModel.name!,
          imageDownloadUrl: productModel.imageDownloadUrl,
          price: productModel.price!);
      await DBHelper.addToCart(AuthService.currentUser!.uid, cartModel);
      _isLoadingaddcart = false; // Set loading state to false
      notifyListeners();
    } catch (error) {
      _isLoadingaddcart =
          false; // Set loading state to false in case of an error
      notifyListeners();
      // Handle the error as needed
    }
  }

  void removeFromCart(String id) async {
    try {
      _isLoadingaddcart = true; // Set loading state to true
      notifyListeners();
      await DBHelper.removeFromCart(AuthService.currentUser!.uid, id);
      _isLoadingaddcart = false; // Set loading state to false
      notifyListeners();
    } catch (error) {
      _isLoadingaddcart =
          false; // Set loading state to false in case of an error
      notifyListeners();
      // Handle the error as needed
    }
  }

  void increaseQty(CartModel cartModel) async {
    try {
      _isLoading = true; // Set loading state to true
      notifyListeners();

      cartModel.qty += 1;
      await DBHelper.updateCartQuantity(
          AuthService.currentUser!.uid, cartModel);

      _isLoading = false; // Set loading state to false
      notifyListeners();
    } catch (error) {
      _isLoading = false; // Set loading state to false in case of an error
      notifyListeners();
      // Handle the error as needed
    }
  }

  void decreaseQty(CartModel cartModel) async {
    try {
      _isLoading = true; // Set loading state to true
      notifyListeners();

      if (cartModel.qty > 1) {
        cartModel.qty -= 1;
        await DBHelper.updateCartQuantity(
            AuthService.currentUser!.uid, cartModel);
      }

      _isLoading = false; // Set loading state to false
      notifyListeners();
    } catch (error) {
      _isLoading = false; // Set loading state to false in case of an error
      notifyListeners();
      // Handle the error as needed
    }
  }

  // void increaseQty(CartModel cartModel) {
  //   cartModel.qty += 1;
  //   DBHelper.updateCartQuantity(AuthService.currentUser!.uid, cartModel);
  // }
  //
  // void decreaseQty(CartModel cartModel) {
  //   if (cartModel.qty > 1) {
  //     cartModel.qty -= 1;
  //     DBHelper.updateCartQuantity(AuthService.currentUser!.uid, cartModel);
  //   }
  // }

  void clearCart() {
    DBHelper.removeAllItemsFromCart(AuthService.currentUser!.uid, cartList);
  }

  bool isInCart(String id) {
    bool tag = false;
    for (var cart in cartList) {
      if (cart.productId == id) {
        tag = true;
        break;
      }
    }
    return tag;
  }

  bool isInDistributorCart(String id) {
    bool tag = false;
    for (var cart in distributorcartList) {
      if (cart.productId == id) {
        tag = true;
        break;
      }
    }
    return tag;
  }

  int get totalItemsInCart => cartList.length;

  num get cartItemsTotalPrice {
    num total = 0;
    cartList.forEach((element) {
      total += element.qty * element.price;
    });
    return total;
  }

  num grandTotal(int discount, int vat, int deliveryCharge) {
    var grandTotal = 0;

    return grandTotal;
  }

  void getAllCartItems() {
    DBHelper.fetchAllCartItems(AuthService.currentUser!.uid).listen((event) {
      cartList = List.generate(event.docs.length,
          (index) => CartModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  void addToDistributorCart(ProductModel productModel) {
    final cartModel = DistributorCartModel(
        productId: productModel.id!,
        productName: productModel.name!,
        price: productModel.price!);
    DBHelper.addToDistributorCart(AuthService.currentUser!.uid, cartModel);
  }

  void increaseDistributorQty(DistributorCartModel cartModel) {
    cartModel.qty += 1;
    DBHelper.updateDistributorCartQuantity(
        AuthService.currentUser!.uid, cartModel);
  }

  void increaseDistributorQty16(DistributorCartModel cartModel) {
    cartModel.qty += 16;
    DBHelper.updateDistributorCartQuantity(
        AuthService.currentUser!.uid, cartModel);
  }

  void decreaseDistributorQty(DistributorCartModel cartModel) {
    if (cartModel.qty > 1) {
      cartModel.qty -= 1;
      DBHelper.updateDistributorCartQuantity(
          AuthService.currentUser!.uid, cartModel);
    }
  }

  void decreaseDistributorQty16(DistributorCartModel cartModel) {
    if (cartModel.qty > 16) {
      cartModel.qty -= 16;
      DBHelper.updateDistributorCartQuantity(
          AuthService.currentUser!.uid, cartModel);
    }
  }

  void getAllDistributorCartItems() {
    DBHelper.fetchAllCartItems(AuthService.currentUser!.uid).listen((event) {
      distributorcartList = List.generate(event.docs.length,
          (index) => DistributorCartModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }
}
