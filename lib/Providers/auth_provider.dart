import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AuthProvider extends  ChangeNotifier{

  File? image;
  String pickerError='';
  bool isPicAvail = false;

  late double latitude;
  late double longitude;
  var shopAddress;
  String? email;

  Future<File?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickerFile = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
    if(pickerFile !=null){
      this.image = File(pickerFile.path);
      notifyListeners();
    }else{
      this.pickerError ='No image selected';
      print('No image selected');
      notifyListeners();
    }
    return this.image;

  }

  Future uploadFile(filePath,imgName) async {
    File file = File(filePath);

    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('uploads/ShopProfilePic/$imgName')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }

    String downloadURL = await _storage
        .ref('uploads/ShopProfilePic/$imgName')
        .getDownloadURL();

    return downloadURL;
  }


  Future<UserCredential?> createUserWithEmailAndPassword(email,password) async{
    this.email = email;
    UserCredential? userCredential;
    try {
      userCredential = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return userCredential;
  }

  Future<UserCredential?> loginWithEmailAndPassword(email,password) async{
    this.email = email;
    UserCredential? userCredential;
    try {
      userCredential = (await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return userCredential;
  }

  Future<UserCredential?> restPassword(email) async{
    this.email = email;
    UserCredential? userCredential;
    try {
       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
     }
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return userCredential;
  }

  Future<void> saveUserData({String? url,String? shopName,String? mobile,String? dialog}) async{
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors = FirebaseFirestore.instance.collection('Vendors').doc(user!.uid);
   await _vendors.set({
      'uid':user.uid,
      'url':url,
      'shopName': shopName,
      'mobile':mobile,
      'email': this.email,
      'dialog':dialog,
      'address': this.shopAddress,
      'location': GeoPoint(this.latitude,this.longitude),
      'shopOpen': true,
      'rating': 0.00,
      'totalRating': 0.00,
      'isTopPicked': false,
      'accVerified': false
    });

    return null;
}


}
