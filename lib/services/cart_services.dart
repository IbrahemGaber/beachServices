

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService{

  CollectionReference cart = FirebaseFirestore.instance.collection('Cart');
  User? user = FirebaseAuth.instance.currentUser;

  Future<void>addToCart(document){
    cart.doc(user!.uid).set({
      'user':user!.uid,
      'sellerId': document.data()['seller'],
    });

    return cart.doc(user!.uid).collection('Products').add({
      'productID':document.data()['productID'],
      'productName':document.data()['productName'],
      'brand':document.data()['brand'],
      'productImage':document.data()['productImage'],
      'price':document.data()['price'],
      'comparedPrice':document.data()['comparedPrice'],
      'sku':document.data()['sku'],
      'stockQuy': '1',
      'total': document.data()['price'],
    });
  }

  Future<void>updateCartQt(docId,qt,total){

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Cart')
        .doc(user!.uid)
        .collection('Products')
        .doc(docId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Product does not exist in Cart");
      }



      // Perform an update on the document
      transaction.update(documentReference, {

        'stockQuy': qt,
        'total':total
      });

      // Return the new count
      return qt;
    })
        .then((value) => print("Updated Cart"))
        .catchError((error) => print("Failed to update: $error"));
  }

  Future<void>deleteCartQt(docId)async{
    return cart.doc(user!.uid).collection('Products').doc(docId).delete();
  }

  Future<QuerySnapshot> getProducts()async{
    return cart.doc(user!.uid).collection('Products').get();
  }

  Future<void>checkProducts()async{
    final snap =await cart.doc(user!.uid).collection('Products').get();
    if(snap.docs.length == 0){
      cart.doc(user!.uid).delete();
    }
  }
  Future<void>deleteCart()async{
    final snap = await cart.doc(user!.uid).collection('Products').get().then((snapShot){
      for(DocumentSnapshot ds in snapShot.docs){
        ds.reference.delete();
      }
    });
  }
/*
  Future<void>CheckProductId(){
    FirebaseFirestore.instance
        .collection('Cart')
        .doc(user.uid)
        .collection('Products')
        .where('productID',isEqualTo: widget.document.get('productID'))
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc['productID'] == widget.document.get('productID')){
          setState(() {
            exist = true;
            qt = int.parse(doc['stockQuy']);
            docId = doc.id;
          });
        }
      });
    });
  }

 */
}