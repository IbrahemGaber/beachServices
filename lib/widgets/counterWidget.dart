

import 'package:beaches_shop/services/cart_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'add_to_card.dart';

class CounterWidget extends StatefulWidget {
  final DocumentSnapshot document;
  final int qt;
  final String docId;
  CounterWidget({required this.document,required this.qt,required this.docId});
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int qt=0;
  CartService cartService = CartService();
  bool exist=true;
  bool updating= false;
  late double total;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        qt = widget.qt;
      });

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return exist?Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      height: 56,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: FittedBox(
            child: Row(
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      updating = true;
                    });
                    if(qt == 1){
                      cartService.deleteCartQt(widget.docId).then((value){
                        setState(() {
                          exist = false;
                        });
                      });
                    }
                    if(qt>1){
                      setState(() {
                        qt--;
                        total = qt * double.parse(widget.document.get('price'));
                      });
                      cartService.updateCartQt(widget.docId,qt.toString(),total.toString()).then((value){
                        setState(() {
                          updating = false;
                        });
                      });
                    }

                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: qt==1?Icon(Icons.delete):Icon(Icons.remove),
                    ),
                  ),
                ),
                updating?Container(height: 35,width: 35,child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),
                ),)
                    :Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15,bottom: 8,top: 8),
                    child:qt!=null?Text(qt.toString(),style: TextStyle(color: Colors.red),):CircularProgressIndicator(),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      qt++;
                      total = qt * double.parse(widget.document.get('price'));
                      updating = true;
                    });
                    cartService.updateCartQt(widget.docId,qt.toString(),total.toString()).then((value){
                      setState(() {
                        updating = false;
                      });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.red
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.add),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ):AddToCard(widget.document);
  }
}
