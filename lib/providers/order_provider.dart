import 'package:flutter/foundation.dart';

import '../db/db_helper.dart';
import '../models/cart_model.dart';
import '../models/order_constants_model.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();
  List<OrderModel> userOrderList = [];List<OrderModel> distributorOrderList = [];
  List<CartModel> orderDetailsList = [];List<CartModel> distributorOrderDetailsList = [];

  void getOrderConstants() async {
    DBHelper.fetchOrderConstants().listen((snapshot) {
      if (snapshot.exists) {
        orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
      }
    });
  }

  void getOrderDetails(String orderId) async {
    DBHelper.fetchAllOrderDetails(orderId).listen((snapshot) {
      orderDetailsList = List.generate(snapshot.docs.length,
          (index) => CartModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }  void getDistributorOrderDetails(String orderId) async {
    DBHelper.fetchAllDistributorOrderDetails(orderId).listen((snapshot) {
      distributorOrderDetailsList = List.generate(snapshot.docs.length,
          (index) => CartModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  void getUserOrders(String userId) async {
    DBHelper.fetchAllOrdersByUser(userId).listen((snapshot) {
      userOrderList = List.generate(snapshot.docs.length,
          (index) => OrderModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }  void getDistributorOrders(String userId) async {
    DBHelper.fetchAllOrdersByDistributor(userId).listen((snapshot) {
      distributorOrderList = List.generate(snapshot.docs.length,
          (index) => OrderModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  num getDiscountAmount(num total) {
    return ((total * orderConstantsModel.discount) / 100);
  }

  num getTotalVatAmount(num total) {
    final totalAfterDiscount = total - getDiscountAmount(total);
    return ((totalAfterDiscount * orderConstantsModel.vat) / 100);
  }

  num getGrandTotal(num total) {
    return (total - getDiscountAmount(total)) +
        getTotalVatAmount(total) +
        orderConstantsModel.deliveryCharge;
  }

  Future<void> addNewOrder(OrderModel orderModel, List<CartModel> cartModels) {
    return DBHelper.addNewOrder(orderModel, cartModels);
  }

  Future<void> addDistributorNewOrder(
      OrderModel orderModel, List<CartModel> cartModels) {
    return DBHelper.addDistributorNewOrder(orderModel, cartModels);
  }
}
