import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CouponProvider with ChangeNotifier{

  bool expired= false;
  late DocumentSnapshot document;
  String discountRate='0';

  getCoupon(title,sellerId) async {
    DocumentSnapshot document = await FirebaseFirestore
        .instance.collection('Coupons').doc(title).get();

    if(document.exists){
      this.document = document;
      notifyListeners();
      if(document.get('sellerId') == sellerId){
        checkExpiry(document);
      }
    }else{
      //this.document = null;
    }
    return document;
  }

  checkExpiry(DocumentSnapshot document){
    DateTime date = DateFormat('y-m-d').parse(document.get('expiry'));
    var  dateDiff = date.difference(DateTime.now()).inDays;
    if(dateDiff<0){
      this.expired = true;
      notifyListeners();
    }else{
      this.document = document;
      this.expired = false;
      this.discountRate = document.get('discountRate');
      notifyListeners();
    }
  }
}