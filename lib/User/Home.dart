
import 'package:beaches_shop/User/Cart.dart';
import 'package:beaches_shop/services/Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Services services = Services();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:  StreamBuilder<QuerySnapshot>(
        stream: services.product.snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapShot){
          if(snapShot.hasError){
            return Text('Error');
          }
          if(snapShot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return Column(
              children:snapShot.data!.docs.map((DocumentSnapshot doc){
            return Padding(
              padding: const EdgeInsets.only(top: 8,bottom: 8,left: 4,right: 4),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder:(context)=>Cart(document: doc,)));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.92,
                        height: 250,
                        child: Image.network(doc.get("productImage"),fit: BoxFit.fill,),),
                    ),
                    SizedBox(height: 10,),
                    Text('${doc.get('productName')}-${doc.get('description')}',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                    Text('${doc.get('price')} ج ',style: TextStyle(color: Colors.red),),
                    SizedBox(height: 10,)
                  ]),
              ));}).toList()
          );
        },
      ),
    );
  }
}
