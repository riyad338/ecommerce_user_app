import 'package:ecommerce_own_user_app/auth/auth_service.dart';
import 'package:ecommerce_own_user_app/models/order_model.dart';
import 'package:flutter/foundation.dart';

import '../db/db_helper.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  Future<void> addUser(UserModel userModel) {
    return DBHelper.addNewUser(userModel);
  }

  Future<UserModel?> getCurrentUser(String userId) async {
    final snapshot = await DBHelper.fetchUserDetails(userId);
    if (!snapshot.exists) {
      return null;
    }
    return UserModel.fromMap(snapshot.data()!);
  }

  Future<void> updateDeliveryAddress(String userId, String address) =>
      DBHelper.updateDeliveryAddress(userId, address);

  Future<void> updateUserProfile(
          String userId, String name, String phone, String address) =>
      DBHelper.updateUserProfile(userId, name, phone, address);

  Future<void> updateImage(String userId, String image) =>
      DBHelper.updateImage(userId, image);
}
