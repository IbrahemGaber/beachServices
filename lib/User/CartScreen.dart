

import 'package:beaches_shop/Providers/CartProvider.dart';
import 'package:beaches_shop/Providers/CouponProvider.dart';
import 'package:beaches_shop/User/HomeScreen.dart';
import 'package:beaches_shop/services/OrderService.dart';
import 'package:beaches_shop/services/cart_services.dart';
import 'package:beaches_shop/services/user_services.dart';
import 'package:beaches_shop/widgets/productList_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final String sellerId;
  final int items;
  final double total;
  CartScreen({required this.items,required this.total,required this.sellerId});
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double deliveryFees = 40.0;
  late CartProvider cartProvider;
  CartService? cartService = CartService();
  OrderServices? orderServices = OrderServices();
  User? user = FirebaseAuth.instance.currentUser;
  UserServ userServices=UserServ();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp){
      cartProvider = Provider.of(context,listen:false);
      cartProvider.getCartDetails();



    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
              textDirection: TextDirection.rtl,
              child:StreamBuilder<QuerySnapshot>(
                stream: cartService!.cart.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData){
                    return Center(child: Text("لا توجد منتاجات",style: TextStyle(fontSize: 20),),);
                  }
                  return Consumer<CartProvider>(
                    builder: (context,provider,child){
                      print(provider.subTotal);
                      return provider.cartQty>0?Scaffold(
                        resizeToAvoidBottomInset: false,
                        bottomSheet: Container(
                          height: 60,
                          color: Colors.blueGrey[900],
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("\$ ${provider.subTotal+deliveryFees}",style: TextStyle(fontSize: 17,color: Colors.white),),
                                          Text("تتضمن الخدمة",style: TextStyle(color: Colors.green,fontSize: 14),)
                                        ],),
                                      TextButton(
                                        onPressed:(){
                                          userServices.getUserData(user!.uid).then((value) {
                                            saveOrder(provider);
                                            EasyLoading.showSuccess('تم الطلب');
                                          });
                                        },
                                        child: Text("تاكيد",style: TextStyle(color: Colors.white,fontSize: 14),),
                                        style: TextButton.styleFrom(
                                            backgroundColor: Theme.of(context).primaryColor
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        body: provider.cartQty>0
                            ?NestedScrollView(
                          headerSliverBuilder: (BuildContext context,bool innerBozIsSxrolled){
                            return [
                              SliverAppBar(
                                  floating: true,
                                  snap: true,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  elevation: 0.0,
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text("${provider.snapshot!.size} | Items ",style: TextStyle(fontSize: 13,color: Colors.white)),
                                          Text(" For Pay : ",style: TextStyle(fontSize: 13,color: Colors.white)),
                                          Text(" ${provider.subTotal.toStringAsFixed(0)} \$",style: TextStyle(fontSize: 13,color: Colors.white)),
                                        ],),
                                    ],

                                  ))
                            ];
                          },
                          body: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: provider.getStoreLoading
                                ?Center(child: CircularProgressIndicator(),)
                                :SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: Column(
                                  children: [
                                    Divider(),
                                    ListOfProducts(),
                                    SizedBox(height: 10,),
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('قيمة الفاتورة',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                            SizedBox(height: 8,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('قيمة المنتجات',style: TextStyle(fontSize: 15,color: Colors.black45),),
                                                Text(provider.subTotal.toStringAsFixed(0),style: TextStyle(fontSize: 15,color: Colors.black45),),
                                              ],
                                            ),
                                            SizedBox(height: 8,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('ضريبة التوصيل',style: TextStyle(fontSize: 15,color: Colors.black45),),
                                                Text(deliveryFees.toStringAsFixed(0),style: TextStyle(fontSize: 15,color: Colors.black45),),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('المبلغ الكلي',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                Text("${((provider.subTotal+deliveryFees))}",style: TextStyle(fontSize: 16,fontWeight:FontWeight.bold,color: Colors.black),),
                                              ],
                                            ),
                                            SizedBox(height: 8,),

                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 180,)

                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                            :Center(child: Text("لا توجد منتجات",style: TextStyle(fontSize: 20),),),
                      ):Scaffold(appBar:AppBar(),body: Center(child: Text('لا توجد منتجات',style: TextStyle(fontSize: 20),),));
                    },);
                },

              )

    );
  }

  saveOrder(CartProvider provider){
    orderServices!.saveOrders({
      'products':provider.cartList,
      'userId':user!.uid,
      'deliveryFee':deliveryFees,
      'total':provider.subTotal,
      'cod': true,
      'sellerId':widget.sellerId,
      'timeStamp':DateTime.now().toString(),
      'orderStatus': 'Ordered',
      'deliveryBoy':{
        'name':'',
        'phone': '',
        'location':''
      }
    }).then((value){
      cartService!.deleteCart().then((value){
        cartService!.checkProducts().then((value){
          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder:(context)=>HomeScreen(0)));
        });

      });
    });

  }
}
