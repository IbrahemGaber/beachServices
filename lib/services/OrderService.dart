

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices{

  CollectionReference orders = FirebaseFirestore.instance.collection('Orders');

  Future<DocumentReference>saveOrders(Map<String,dynamic>data)async{
    var result = orders.add(
        data
    );
    return result;
  }
}