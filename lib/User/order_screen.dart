


import 'package:beaches_shop/Providers/OrderProvider.dart';
import 'package:beaches_shop/services/OrderService.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:ui'as ui;

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  OrderServices orderServices = OrderServices();
  late OrderProvider orderProvider;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      orderProvider = Provider.of(context,listen:false);
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context,provider,child){
        return Scaffold(
              body:Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: orderServices.orders
                      .where('userId',isEqualTo: user!.uid)
                      .snapshots(),
                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                    if(snapshot.hasError){
                      return Text('Error In Data');
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    if(snapshot.data!.size == 0){
                      return Center(child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('لا توجد طلبات اذهب للتسوق',style: TextStyle(fontSize: 18),)
                      ),);
                    }
                    return SingleChildScrollView(
                          child:Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListView(
                                    shrinkWrap: true,
                                    children: snapshot.data!.docs.map((doc){
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              ListTile(
                                                  title: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children:[
                                                        Text(doc.get('orderStatus'), style: TextStyle(color: doc.get('orderStatus')=='Rejected'?Colors.red:doc.get('orderStatus')=='Accepted'?Colors.blueGrey:Theme.of(context).primaryColor),),
                                                        Text(DateFormat('yMMMMd').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(doc.get('timeStamp'))),style: TextStyle(color: Colors.black54),)
                                                      ]),
                                                  leading: Icon(Icons.featured_play_list_rounded,color: Theme.of(context).primaryColor,size: 18,),
                                                  minLeadingWidth: 25.0,
                                                  trailing:Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text("طريقة الدفع : ${doc.get('cod') == false ? 'اونلاين': 'كاش'}"),
                                                      Text('المبلغ : ${doc.get('total')} \$'),
                                                    ],)
                                              ),
                                              ExpansionTile(
                                                title: Text('تفاصيل الطلب'),
                                                subtitle: Text('عرض المزيد',style: TextStyle(color: Colors.black45),),
                                                children: [
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: doc.get('products').length,
                                                    itemBuilder: (context,index){
                                                      return Padding(
                                                        padding: const EdgeInsets.only(top: 8,bottom: 8,right: 20,left: 20),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(width: 45,height: 45,
                                                                  child: Image.network(doc.get('products')[index]['productImage'],fit: BoxFit.contain,),),
                                                                SizedBox(width: 15,),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(doc.get('products')[index]['productName']),
                                                                    Text("${doc.get('products')[index]['stockQuy']} x ${double.parse(doc.get('products')[index]['price']).toStringAsFixed(0)} = ${double.parse(doc.get('products')[index]['total']).toStringAsFixed(0)}",style: TextStyle(color: Colors.black45), ),

                                                                  ],
                                                                )

                                                              ],
                                                            ),
                                                          ],),
                                                      );
                                                    },
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom:5,right: 20,left: 20),
                                                    child: Row(
                                                      children: [
                                                        Text('خدمة الدليفري : ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                        Text("${doc.get('deliveryFee').toStringAsFixed(0)}")
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),),
                                ],
                              ),
                            ),
                          )
                      );
                  }
              ),
            ],
          ),
        );
        },
      );
  }
}
