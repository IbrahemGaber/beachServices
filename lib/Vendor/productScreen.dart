
import 'package:beaches_shop/widgets/published_product.dart';
import 'package:beaches_shop/widgets/unpublished_product.dart';
import 'package:flutter/material.dart';
import 'addNewProductScreen.dart';

class ProductScreen extends StatefulWidget {
  static const String id = 'product-screen';
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Material(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text('المنتاجات'),
                          SizedBox(width: 10,),
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                            maxRadius: 8,
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('20',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10,),
                    TextButton(onPressed:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewProductScreen()));
                    },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add,color: Colors.white,),
                          Text('اضافة منتج',style: TextStyle(color: Colors.white),)
                        ],
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),)
                  ],
                ),
              ),
            ),
            TabBar(
              indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                tabs: [
              Tab(text: 'نشر',),
              Tab(text: 'عدم النشر ',)
            ]),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  PublishedProducts(),
                  UnpublishedProducts()
                ],),
              ),
            )
          ],
        ),
      ),
    );
  }
}
