import 'package:beaches_shop/bootsheet_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  final DocumentSnapshot document;
  Cart({required this.document});
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    String offer = (((double.parse(widget.document.get('comparedPrice'))-double.parse(widget.document.get('price')))
        /double.parse(widget.document.get('comparedPrice')))*100).toStringAsFixed(0);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
              iconTheme: IconThemeData(
                  color: Colors.white
              ),
              actions:[
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
              ]),
          bottomSheet: BootSheet(widget.document),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(.3),
                          border: Border.all(
                              color: Theme.of(context).primaryColor
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3,bottom: 3,left: 15,right: 15),
                        child: Text(widget.document['brand'],style: TextStyle(fontSize: 16),),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Text(widget.document['productName'],style: TextStyle(fontSize: 22)),
                //Text(widget.document['weight'],style: TextStyle(fontSize: 20)),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text('\$${widget.document['price']}',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                    SizedBox(width: 10,),
                    if(int.parse(offer)>0)
                      Text('\$${widget.document['comparedPrice']}',style: TextStyle(fontSize: 15,decoration:TextDecoration.lineThrough),),
                    SizedBox(width: 10,),
                    if(int.parse(offer)>0)
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(topLeft:Radius.circular(8),bottomRight: Radius.circular(8))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2,bottom: 2,right: 3,left: 3),
                          child: Text('${offer}%OFF',style: TextStyle(color: Colors.white),),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: 'المنتج ${widget.document.get('productName')}',
                    child: Image.network(widget.document['productImage'],
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height*.48,
                      width: MediaQuery.of(context).size.width,),
                  ),
                ),
                Divider(
                  thickness: 5,
                  color: Colors.grey,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('وصف المنتج',style: TextStyle(fontSize: 21),),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(widget.document['description'],style: TextStyle(fontSize: 18,color: Colors.black54)),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('موواصفات اخري للمنتج',style: TextStyle(fontSize: 21),),
                ),
                SizedBox(height: 10,),
                Text('الكود: ${widget.document['sku']}',style: TextStyle(fontSize: 16,color: Colors.grey),),
                SizedBox(height: 8,),
                //Text('Seller: ${widget.document['seller.shopName']}',style: TextStyle(fontSize: 16,color: Colors.grey)),
                SizedBox(height: 60,)


              ],
            ),
          )
      ),
    );
  }

}
