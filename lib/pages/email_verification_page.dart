import 'dart:async';

import 'package:ecommerce_own_user_app/auth/auth_service.dart';
import 'package:ecommerce_own_user_app/pages/product_list_page.dart';
import 'package:ecommerce_own_user_app/utils/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const String routeName = '/email_verification';

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    AuthService.sendVerificationMail();
    // FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = AuthService.isUserVerified();
      // FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      Navigator.pushReplacementNamed(context, ProductListPage.routeName);
      showMsg(context, "Email Successfully Verified");
      timer?.cancel();
    } else {
      await FirebaseAuth.instance.signOut();
      return null;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 35.h),
          SizedBox(height: 30.h),
          Center(
            child: Text(
              'Check your \n Email',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Center(
              child: Text(
                'We have sent you a Email on  ${FirebaseAuth.instance.currentUser?.email}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          const Center(
              child: CircularProgressIndicator(
            color: Colors.greenAccent,
          )),
          SizedBox(height: 8.h),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Center(
              child: Text(
                'Verifying email....',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 57.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
              child: const Text('Resend'),
              onPressed: () {
                try {
                  AuthService.sendVerificationMail();
                } catch (e) {
                  debugPrint('$e');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
