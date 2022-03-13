

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Services{

  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');
  CollectionReference product = FirebaseFirestore.instance.collection('Products');
  CollectionReference cart = FirebaseFirestore.instance.collection('Cart');
  static String? type;
  static String? type2;

  Future<QuerySnapshot> getProduct()async{
    return cart.doc(user!.uid).collection('Products').get();
  }

  Future<void> addUser(name,email,address,phone,type,uid)async {
    return await users.doc(uid).set({
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
      'type': type,
      'uid':uid
    });
  }

  Future<void> addVendor(name,email,address,phone,type,uid)async {
    return await vendors.doc(uid).set({
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
      'type': type,
      'uid':uid
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    var result = users.doc(user!.uid).get();

    return result;
  }


  Future<DocumentSnapshot> getVendorData() async {
    var result = vendors.doc(user!.uid).get();

    return result;
  }

  Future<DocumentSnapshot> getProducts() async {
    var result = product.doc(user!.uid).get();

    return result;
  }
}