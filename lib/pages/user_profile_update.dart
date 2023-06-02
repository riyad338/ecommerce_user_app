import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce_own_user_app/auth/auth_service.dart';
import 'package:ecommerce_own_user_app/models/user_model.dart';
import 'package:ecommerce_own_user_app/pages/user_profile_update.dart';
import 'package:ecommerce_own_user_app/providers/user_provider.dart';
import 'package:ecommerce_own_user_app/utils/helper_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfileUpdatePage extends StatefulWidget {
  static const String routeName = '/user_profile_update';

  @override
  State<UserProfileUpdatePage> createState() => _UserProfileUpdatePage();
}

class _UserProfileUpdatePage extends State<UserProfileUpdatePage> {
  UserModel _userModel = UserModel(
    userId: AuthService.currentUser!.uid,
    email: "",
  );
  bool isSaving = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addreessController = TextEditingController();

  ImageSource _imageSource = ImageSource.camera;
  String? _imagePath;
  late UserProvider _userProvider;

  String? userImage;
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _userProvider = Provider.of<UserProvider>(context);
      _userProvider.getCurrentUser(AuthService.currentUser!.uid).then((user) {
        if (user != null) {
          _emailController.text = user.email;
          _nameController.text = user.name!;
          _phoneController.text = user.phone!;
          _addreessController.text = user.deliveryAddress!;
          userImage = user.picture;
          setState(() {});
        }
      });
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addreessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
        backgroundColor: Colors.greenAccent,
        actions: [
          Container(
            width: 50.w,
            child: IconButton(
              padding: EdgeInsets.symmetric(vertical: 12),
              onPressed: () {
                _updateUserInformation();
                _uploadImage();
              },
              icon: Text("Update"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
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
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.0.r),
                          child: Container(
                            height: 100.h,
                            width: 100.w,
                            child: _imagePath == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.black12,
                                    radius: 80.r,
                                    backgroundImage: NetworkImage(
                                        userImage == null ? "" : userImage!),
                                  )
                                : Image.file(
                                    File(_imagePath!),
                                    width: 100.w,
                                    height: 100.h,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 1,
                          child: CircleAvatar(
                              child: IconButton(
                                  onPressed: () {
                                    _updateProfileimage();
                                  },
                                  icon: Icon(Icons.edit))),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit),
                        prefixIcon: Icon(Icons.person),
                        hintStyle: TextStyle(color: Colors.black12),
                        hintText: "Name",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r))),
                        filled: true,
                        fillColor: Colors.greenAccent.shade100,
                      ),
                      controller: _nameController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        suffixIcon: Icon(Icons.lock),
                        enabled: false,
                        hintStyle: TextStyle(color: Colors.black12),
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r))),
                        filled: true,
                        fillColor: Colors.greenAccent.shade100,
                      ),
                      controller: _emailController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit),
                        prefixIcon: Icon(Icons.call),
                        hintText: "Phone",
                        hintStyle: TextStyle(color: Colors.black12),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r))),
                        filled: true,
                        fillColor: Colors.greenAccent.shade100,
                      ),
                      controller: _phoneController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit),
                        prefixIcon: Icon(Icons.home),
                        hintText: "Adreess",
                        hintStyle: TextStyle(color: Colors.black12),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r))),
                        filled: true,
                        fillColor: Colors.greenAccent.shade100,
                      ),
                      controller: _addreessController,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _updateProfileimage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 20,
          content: Text("Please select"),
          actions: [
            ElevatedButton.icon(
              icon: Icon(
                Icons.camera,
                color: Colors.black,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade100),
              label: Text(
                'Camera',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                _imageSource = ImageSource.camera;
                _pickImage();
              },
            ),
            SizedBox(
              width: 10.w,
            ),
            ElevatedButton.icon(
              icon: Icon(
                Icons.image,
                color: Colors.black,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade100),
              label: Text(
                'Gallery',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                _imageSource = ImageSource.gallery;
                _pickImage();
              },
            ),
          ],
        );
      },
    );
  }

  _updateUserInformation() async {
    final isConnected = await isConnectedToInternet();
    if (isConnected) {
      _userProvider.updateUserProfile(
          AuthService.currentUser!.uid,
          _nameController.text,
          _phoneController.text,
          _addreessController.text);
      showToastMsg("Update your profile");
    } else {
      showMsg(context, 'No internet connection detected.');
    }
  }

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: _imageSource, imageQuality: 60);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        Navigator.pop(context);
      });
    }
  }

  void _uploadImage() async {
    final imageName =
        '${_userModel.email}_${DateTime.now().microsecondsSinceEpoch}';
    final photoref =
        FirebaseStorage.instance.ref().child('UsersPhoto/$imageName');
    final uploadtask = photoref.putFile(File(_imagePath!));
    final snapshot = await uploadtask.whenComplete(() {});
    final downloadurl = await snapshot.ref.getDownloadURL();
    // _userModel.picture = downloadurl;
    _userProvider.updateImage(AuthService.currentUser!.uid, downloadurl);
  }
}
