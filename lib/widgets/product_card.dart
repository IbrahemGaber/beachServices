
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'Conuter.dart';

class ProductCard extends StatefulWidget {

  final DocumentSnapshot document;
  ProductCard(this.document);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1,color: Colors.grey)
          )
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 8),
            child: Row(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: (){
                      /*
                      pushNewScreenWithRouteSettings(
                          context,
                          screen:ProductDetails(document: widget.document,),
                          settings: RouteSettings(name: ProductDetails.id),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino);
                          
                       */
                    },
                    child: SizedBox(
                        height: 120,width: 130,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Hero(
                                tag: 'product ${widget.document.get('productName')}',
                                child: Image.network(widget.document.get('productImage'),fit: BoxFit.fill,)))),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(widget.document.get('brand'),style: TextStyle(fontSize: 10),),
                            //SizedBox(height: 6,),
                            Text(widget.document.get('productName'),style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(height: 4,),
                          ],
                        ),
                      ),
                      Text("\$${double.parse(widget.document.get('price')).toStringAsFixed(0)}"
                          ,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                      SizedBox(width: 8,),
                      if(double.parse(widget.document.get('comparedPrice'))>0)
                        Text("\$${double.parse(widget.document.get('comparedPrice')).toStringAsFixed(0)}"
                          ,style:TextStyle(decoration: TextDecoration.lineThrough,color: Colors.grey,fontWeight: FontWeight.bold),),
                      Container(
                          width: MediaQuery.of(context).size.width-180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CounterForCard(widget.document)
                            ],
                          )
                      ),
                    ],),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
