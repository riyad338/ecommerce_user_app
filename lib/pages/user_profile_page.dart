import 'package:ecommerce_own_user_app/auth/auth_service.dart';
import 'package:ecommerce_own_user_app/pages/user_profile_update.dart';
import 'package:ecommerce_own_user_app/providers/theme_provider.dart';
import 'package:ecommerce_own_user_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = '/user_profile';

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late UserProvider _userProvider;
  String? userName;
  String? userEmail;
  String? userPhone;
  String? userAddress;
  String? userImage;
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _userProvider = Provider.of<UserProvider>(context);
      _userProvider.getCurrentUser(AuthService.currentUser!.uid).then((user) {
        if (user != null) {
          userEmail = user.email;
          userName = user.name;
          userPhone = user.phone;
          userAddress = user.deliveryAddress;
          userImage = user.picture;
        }
        setState(() {});
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text("My Profile"),
        actions: [
          IconButton(
            padding: EdgeInsets.symmetric(vertical: 10),
            onPressed: () {
              Navigator.pushNamed(context, UserProfileUpdatePage.routeName);
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: 350.w,
              height: 500.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black12,
                    radius: 80.r,
                    backgroundImage:
                        NetworkImage(userImage == null ? "" : userImage!),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    tileColor: themeProvider.themeModeType == ThemeModeType.Dark
                        ? Colors.grey
                        : Colors.greenAccent.shade100,
                    title: Text(userName == null ? "" : userName.toString()!),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    tileColor: themeProvider.themeModeType == ThemeModeType.Dark
                        ? Colors.grey
                        : Colors.greenAccent.shade100,
                    title: Text(userEmail == null ? "" : userEmail!),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListTile(
                    leading: Icon(Icons.call),
                    tileColor: themeProvider.themeModeType == ThemeModeType.Dark
                        ? Colors.grey
                        : Colors.greenAccent.shade100,
                    title: Text(userPhone == null ? "" : userPhone!),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    tileColor: themeProvider.themeModeType == ThemeModeType.Dark
                        ? Colors.grey
                        : Colors.greenAccent.shade100,
                    title: Text(userAddress != null ? userAddress! : ""),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
