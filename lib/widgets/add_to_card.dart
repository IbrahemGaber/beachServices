
import 'package:beaches_shop/Providers/CartProvider.dart';
import 'package:beaches_shop/User/CartScreen.dart';
import 'package:beaches_shop/services/cart_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'counterWidget.dart';

class AddToCard extends StatefulWidget {
  final DocumentSnapshot document;
  AddToCard(this.document);
  @override
  _AddToCardState createState() => _AddToCardState();
}

class _AddToCardState extends State<AddToCard> {

  CartService cartService = CartService();
  User? user = FirebaseAuth.instance.currentUser;
  bool loading =true;
  bool exist = false;
  int qt=0;
  late String docId;

  void CheckProductId()async{
    FirebaseFirestore.instance
        .collection('Cart')
        .doc(user!.uid)
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
  late CartProvider cartProvider;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      cartProvider = Provider.of(context,listen:false);
      cartProvider.getCartDetails();
      getCartData();
      CheckProductId();
    });
    super.initState();
  }

  getCartData()async{
   final snapShot = await cartService.cart.doc(user!.uid).collection('Products').get();
   if(snapShot.docs.length == 0){
     setState(() {
       loading = false;
     });
   }else{
     setState(() {
       loading = false;
     });
   }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ?Container(child: Center(child: CircularProgressIndicator(),),)
         :exist
        ? CounterWidget(document:widget.document,qt: qt,docId: docId,)
        :Consumer<CartProvider>(
      builder: (context,provider,child){
        return InkWell(
          onTap: (){
            CheckProductId();
            EasyLoading.show(status: "اضافة الي عربة التسوق");
            cartService.addToCart(widget.document).then((value){
              setState(() {
                exist=true;
              });
              EasyLoading.showSuccess("تمت الاضافة");
            });

          },
          child: Container(
            height: 56,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_basket_outlined,color: Colors.white,),
                      SizedBox(width: 5,),
                      Text('اضافة الي عربة التسوق',style: TextStyle(color: Colors.white),)
                    ],
                  )
              ),
            ),
          ),
        );
      },
        );
  }
}
