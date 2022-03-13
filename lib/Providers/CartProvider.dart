import 'package:beaches_shop/services/cart_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier{

  CartService cartService = CartService();
  late double subTotal=0.0;
  double totalSaving=0.0;
  int cartQty=0;
  QuerySnapshot? snapshot;
  late String sellerId='';
  DocumentSnapshot? documentSnapshot;
  bool getStoreLoading = true;
  bool toggleIndex = false;
  List cartList=[];

  Future<void>getCartDetails()async{
    double cartTotal = 0.0;
    double cartSaving = 0.0;
    DocumentSnapshot documentSnapshot = await cartService.cart.doc(cartService.user!.uid).get();
    QuerySnapshot snapshot = await cartService.cart.doc(cartService.user!.uid).collection('Products').get();
      this.sellerId = documentSnapshot.get('sellerId');
      snapshot.docs.forEach((doc) {
        cartTotal = cartTotal + double.parse(doc.get('total'));
        print("inside$cartTotal");
        cartSaving = cartSaving + (double.parse("${doc.get('comparedPrice')}") - double.parse("${doc.get('price')}"))*double.parse("${doc.get('stockQuy')}");
      });
    this.subTotal = cartTotal;
    notifyListeners();
    this.totalSaving = cartSaving;
    this.cartQty = snapshot.docs.length;
    this.snapshot = snapshot;
    getStoreLoading = false;
      notifyListeners();

  }

}