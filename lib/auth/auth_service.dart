import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_own_user_app/pages/distributor_order_list_page.dart';
import 'package:ecommerce_own_user_app/pages/distributor_product_list.dart';
import 'package:ecommerce_own_user_app/pages/product_list_page.dart';
import 'package:ecommerce_own_user_app/pages/user_order_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get currentUser => _auth.currentUser;

  static Future<User?> loginUser(String email, String pass) async {
    final credential =
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
    return credential.user;
  }

  static Future<User?> registerUser(String email, String pass) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: pass);
    return credential.user;
  }

  static bool isUserVerified() => _auth.currentUser?.emailVerified ?? false;

  static Future<void> sendVerificationMail() {
    return _auth.currentUser!.sendEmailVerification();
  }

  static Future<void> resetPassword(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> roleBaseLogin(context) async {
    if (_auth.currentUser != null) {
      var userType = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser?.uid)
          .get();

      if (userType['role'] == 'User') {
        Navigator.pushReplacementNamed(context, ProductListPage.routeName);
      } else if (userType['role'] == 'Distributor') {
        Navigator.pushReplacementNamed(
            context, DistributorProductListPage.routeName);
      }
    }
  }

  static Future<void> roleBaseOrderHistroy(context) async {
    if (_auth.currentUser != null) {
      var userType = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser?.uid)
          .get();

      if (userType['role'] == 'User') {
        Navigator.pushNamed(context, UserOrderListPage.routeName);
      } else if (userType['role'] == 'Distributor') {
        Navigator.pushNamed(context, DistributorOrderListPage.routeName);
      }
    }
  }

  static Future<void> logout() {
    return _auth.signOut();
  }
}
