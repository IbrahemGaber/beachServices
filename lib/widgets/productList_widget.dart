
import 'package:beaches_shop/services/Services.dart';
import 'package:beaches_shop/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfProducts extends StatefulWidget {
  @override
  _ListOfProductsState createState() => _ListOfProductsState();
}

class _ListOfProductsState extends State<ListOfProducts> {

  Services services = Services();
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      services.getProducts();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: services.getProduct().asStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: snapshot.data!.docs.map<Widget>((document){
              return ProductCard(document);
            }).toList(),
          );
        }
    );
  }
}
