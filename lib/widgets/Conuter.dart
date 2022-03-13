import 'package:beaches_shop/services/cart_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CounterForCard extends StatefulWidget {
  final DocumentSnapshot document;
  CounterForCard(this.document);
  @override
  _CounterForCardState createState() => _CounterForCardState();
}

class _CounterForCardState extends State<CounterForCard> {

  CartService cartService = CartService();
  User? user = FirebaseAuth.instance.currentUser;
  late int qt;
  late String docId;
  bool exist=false;
  bool updating= false;
  late int total;

  Future<void> CheckProductId()async{
    await FirebaseFirestore.instance
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
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp){
       CheckProductId();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return exist?Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(6)
      ),
     width: 110,
      height: 33,
      child: Center(
        child: FittedBox(
          child: Row(
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    updating = true;
                  });
                  if(qt == 1){
                    cartService.deleteCartQt(docId).then((value){
                      setState(() {
                        exist = false;
                      });
                    });
                  }
                  if(qt>1){
                    setState(() {
                      qt--;
                      total = qt * double.parse(widget.document.get('price')).toInt();
                    });
                    cartService.updateCartQt(docId,qt.toString(),total.toString()).then((value){
                      setState(() {
                        updating = false;
                      });
                    });
                  }

                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: qt==1?Icon(Icons.delete,size: 27,color: Theme.of(context).primaryColor,):Icon(Icons.remove,size: 27,color: Theme.of(context).primaryColor,),
                  ),
                ),
              ),
              Container(
                width: 45,height: 43,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                ),
                child: Center(child: updating?CircularProgressIndicator(color: Colors.white,):Text(qt.toString(),style: TextStyle(color: Colors.white,fontSize: 20,),)),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    qt++;
                    total = qt * double.parse(widget.document.get('price')).toInt();
                    updating = true;
                  });
                  cartService.updateCartQt(docId,qt.toString(),total.toString()).then((value){
                    setState(() {
                      updating = false;
                    });
                  });
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.add,size: 27,color: Theme.of(context).primaryColor,),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    )
        :TextButton(
        onPressed: (){
          CheckProductId();
          EasyLoading.show(status: "Adding cart");
          cartService.addToCart(widget.document).then((value){
            setState(() {
              exist=true;
            });
            EasyLoading.showSuccess("Added cart");
          });

        },
        child:Text("Add",style: TextStyle(color: Colors.white),),
    style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor,padding: EdgeInsets.zero),);
  }
}
