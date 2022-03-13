

import 'package:beaches_shop/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../Providers/product_provider.dart';

class BannerCard extends StatefulWidget {
  @override
  _BannerCardState createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    return StreamBuilder<QuerySnapshot>(
        stream: _services.vendorBanner.snapshots(),
        builder: (context , snaphot){
          if(snaphot.hasError){
            return Text('Something Error');
          }
          if(snaphot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }

          return Container(
            height: 180,
            child: ListView(
              physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: snaphot.data!.docs.map((DocumentSnapshot document) {
                  return Stack(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(document.get("BannerImage"),fit: BoxFit.fill,)),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child:TextButton(
                          child: Icon(Icons.delete_outline,color: Colors.red,),
                          onPressed: (){
                            _services.deleteVendorBanner(document.id);
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: CircleBorder(),
                              padding: EdgeInsets.zero
                          ),
                        ),
                      )
                    ],
                  );
                }).toList()
            ),
          );
        }
    );
  }
}
