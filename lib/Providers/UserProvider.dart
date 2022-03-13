import 'package:beaches_shop/services/Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  Services services = Services();
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String? userr;
  String? vendore;


  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      services.getUserData().then((doc) {
        userr = doc.get('type');
        prefs.setString('user', userr!);
        notifyListeners();
      });
    }catch(e){}
  }

  Future<void> getVendor() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      services.getVendorData().then((doc) {
        vendore = doc.get('type');
        prefs.setString('vendor', vendore!);
        notifyListeners();
      });
    } catch (e) {}
  }
}