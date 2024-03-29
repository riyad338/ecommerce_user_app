import 'package:ecommerce_own_user_app/db/db_helper.dart';
import 'package:ecommerce_own_user_app/pages/email_verification_page.dart';
import 'package:ecommerce_own_user_app/pages/phone_number_login_page.dart';
import 'package:ecommerce_own_user_app/pages/product_list_page.dart';
import 'package:ecommerce_own_user_app/providers/theme_provider.dart';
import 'package:ecommerce_own_user_app/utils/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../auth/auth_service.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _resetemailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String _errMsg = '';

  bool isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.themeModeType == ThemeModeType.Dark
            ? Colors.black12
            : Colors.white70,
        elevation: 0,
        actions: [
          Icon(
            Icons.dark_mode,
            color: themeProvider.themeModeType == ThemeModeType.Dark
                ? Colors.white
                : Colors.black,
          ),
          Switch(
            activeColor: Colors.white,
            inactiveThumbColor: Colors.black,
            value: themeProvider.themeModeType == ThemeModeType.Dark,
            onChanged: (value) {
              setState(() {
                themeProvider.toggleTheme();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(""), fit: BoxFit.fill),
        ),
        child: Center(
            child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 40),
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset("images/primecafe.png"),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r)),
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email Address'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return emptyFieldErrMsg;
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return ("Please Enter a valid Email");
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: _passwordController,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.r)),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        hintText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return emptyFieldErrMsg;
                      }
                      return null;
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        _showDialog(context);
                      },
                      child: Text("Reset Password")),
                  SizedBox(
                    height: 10.h,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r)),
                      backgroundColor: Colors.greenAccent,
                    ),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      isLogin = true;
                      _loginUser();
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New User? Click '),
                      TextButton(
                        style: TextButton.styleFrom(primary: Colors.blue),
                        child: Text(
                          'Reginster',
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          isLogin = false;
                          _loginUser();
                        },
                      )
                    ],
                  ),
                  Text(
                    _errMsg,
                    style: TextStyle(color: Colors.red),
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1.h,
                            color: Colors.grey,
                            margin: EdgeInsets.symmetric(horizontal: 12.w),
                          ),
                        ),
                        Text(
                          "OR",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: themeProvider.themeModeType ==
                                      ThemeModeType.Dark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        Expanded(
                          child: Container(
                            height: 1.h,
                            color: Colors.grey,
                            margin: EdgeInsets.symmetric(horizontal: 12.w),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, PhoneAuthPage.routeName);
                    },
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(25.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.white70,
                              radius: 25.r,
                              child: Icon(
                                Icons.call,
                                color: Colors.green,
                              )),
                          SizedBox(
                            width: 30.w,
                          ),
                          Text(
                            "Continue with Phone",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InkWell(
                    onTap: () async {
                      await _handleSignIn();
                    },
                    child: Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(25.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.white70,
                              radius: 25.r,
                              child: Image.asset(
                                "images/goo.png",
                                height: 30.h,
                              )),
                          SizedBox(
                            width: 30.w,
                          ),
                          Text(
                            "Continue with Google",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  void _loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user;
        if (isLogin) {
          user = await AuthService.loginUser(
              _emailController.text, _passwordController.text);
        } else {
          user = await AuthService.registerUser(
              _emailController.text, _passwordController.text);
        }
        if (user != null) {
          if (!isLogin) {
            final userModel = UserModel(
              userId: user.uid,
              email: user.email!,
              userCreationTime:
                  user.metadata.creationTime!.millisecondsSinceEpoch,
            );
            Provider.of<UserProvider>(context, listen: false)
                .addUser(userModel)
                .then((value) {
              Navigator.pushReplacementNamed(
                  context, EmailVerificationScreen.routeName);
            });
          } else {
            AuthService.roleBaseLogin(context);
            showToastMsg("Login Successfully");
          }
        }
      } on FirebaseAuthException catch (error) {
        showToastMsg(error.message!);
      }
    }
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 20,
          title: Text("Reset your password"),
          content: TextFormField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.edit),
              hintText: "Email",
            ),
            controller: _resetemailController,
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: 20.w,
            ),
            ElevatedButton(
              child: Text("Send"),
              onPressed: () {
                AuthService.resetPassword(_resetemailController.text);

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mail sent. Pleae check your inbox'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignInf = GoogleSignIn();
  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignInf.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          bool isFirstTimeSignIn = await DBHelper.isUserExists(user.uid);

          if (!isFirstTimeSignIn) {
            // Add the user's data to the database using UserModel.
            UserModel userModel = UserModel(
              userId: user.uid,
              name: user.displayName,
              email: user.email!,
              userCreationTime:
                  user.metadata.creationTime!.millisecondsSinceEpoch,
            );

            // Save user data in your user collection
            Provider.of<UserProvider>(context, listen: false)
                .addUser(userModel);
            Navigator.pushReplacementNamed(context, ProductListPage.routeName);
          }

          // Proceed to the main screen or any other screen.
          AuthService.roleBaseLogin(context);
          showToastMsg("Login Successfully");
        }
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
    }
  }
}
