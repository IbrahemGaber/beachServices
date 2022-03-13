
import 'package:beaches_shop/services/OrderService.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:ui'as ui;

import '../Providers/OrderProvider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  int tag = 0;
  List<String> options = [
    'All Orders','Ordered', 'Accepted', 'Picked Up','On the way', 'Delivered',
  ];

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

  Color statusColors(DocumentSnapshot doc){
    if(doc.get('orderStatus') == 'Accepted'){
      return Colors.blueGrey;
    }
    if(doc.get('orderStatus') == 'Rejected'){
      return Colors.red;
    }
    if(doc.get('orderStatus') == 'Picked Up'){
      return Colors.pink;
    }
    if(doc.get('orderStatus') == 'On the way'){
      return Colors.purple;
    }
    if(doc.get('orderStatus') == 'Delivered'){
      return Colors.green;
    }
    return Theme.of(context).primaryColor;
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context,provider,child){
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Scaffold(
                body:ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      color: Colors.grey,
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Orders',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
                      ),
                    ),
                StreamBuilder<QuerySnapshot>(
                    stream: tag == 0 ?orderServices.orders
                        .where('sellerId',isEqualTo: user!.uid)
                        .snapshots():orderServices.orders
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
                          child: Text(" لا يوجد اي طلب الان.."),
                        ),);
                      }
                      return SingleChildScrollView(
                            child:ListView(
                              scrollDirection: Axis.vertical,
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
                                                  Text(doc.get('orderStatus'),
                                                    style: TextStyle(color: statusColors(doc))),
                                                  Text(DateFormat('yMMMMd').format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(doc.get('timeStamp'))),style: TextStyle(color: Colors.black54),)
                                                ]),
                                            leading: Icon(Icons.featured_play_list_rounded,color: Theme.of(context).primaryColor,size: 18,),
                                            minLeadingWidth: 25.0,
                                            trailing:Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text("طريقة الدفع : ${doc.get('cod') == false ? 'اون لاين': 'كاش'}"),
                                                Text('Amount : ${doc.get('total')} \$'),
                                              ],)
                                        ),
                                        ExpansionTile(
                                          title: Text('تفاصيل المنتج'),
                                          subtitle: Text('عرض التفاصيل',style: TextStyle(color: Colors.black45),),
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
                                                  Text('خدمة التوصيل : ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                  Text("${doc.get('deliveryFee').toStringAsFixed(0)}")
                                                ],
                                              ),
                                            )
                                          ],
                                        ),

                                        doc.get('orderStatus')=='Accepted'
                                            ? Container(
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 20,right: 20),
                                                  child: TextButton(onPressed:(){
                                                    showDialog("موافقة الطلب",doc.id,'تمت الموافقه');
                                                  },
                                                    child: Text('ارسال الطلب',style: TextStyle(color: Colors.white,fontSize: 17),),
                                                    style: TextButton.styleFrom(
                                                        backgroundColor: Theme.of(context).primaryColor
                                                    ),),
                                                ),
                                              ),
                                              SizedBox(width: 5,),

                                            ],
                                          ),
                                        )
                                            :Container(
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextButton(onPressed:(){
                                                  showDialog("موافقة الطلب",doc.id,'تمت الموافقة');
                                                },
                                                    child: Text('موافق',style: TextStyle(color: Colors.white,fontSize: 17),),
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.black45
                                                ),),
                                              ),
                                              SizedBox(width: 5,),
                                              Expanded(
                                                child: AbsorbPointer(
                                                  absorbing: doc.get('orderStatus')=='Rejected'?true:false,
                                                  child: TextButton(
                                                    onPressed:(){
                                                      showDialog('رفض الطلب',doc.id,"تم الرفض");
                                                    },
                                                      child: Text('رفض',style: TextStyle(color: Colors.white,fontSize: 17)),
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: doc.get('orderStatus')=='Rejected'?Colors.blueGrey:Theme.of(context).primaryColor
                                                  ),),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],

                                    ),
                                  ),
                                );
                              }).toList(),)
                        );
                    }
                ),
              ],
            ),
          ),
        );
        },
      );
  }

  showDialog(title,documentId,status){
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context){
          return Consumer<OrderProvider>(
            builder: (context,provider,child){
              return CupertinoAlertDialog(
                title: Text(title),
                content: Text('هل انت متاكد؟'),
                actions: [
                  TextButton(
                      onPressed:(){
                        /*
                        EasyLoading.show(status: 'Updating Order...');
                        orderServices.updateOrderStatus(documentId, status).then((value){
                          EasyLoading.showSuccess("Updated");
                        });
                        Navigator.pop(context);

                         */
                      },

                      child: Text('موافق',style: TextStyle(color: Theme.of(context).primaryColor),)
                  ),
                  TextButton(
                      onPressed:(){
                        Navigator.pop(context);
                      },
                      child: Text('الغاء',style: TextStyle(color: Theme.of(context).primaryColor),)
                  )
                ],
              );
            },
          );
        });
  }
}
