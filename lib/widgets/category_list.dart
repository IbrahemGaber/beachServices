

import 'package:beaches_shop/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/product_provider.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  FirebaseServices services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    var _productProvider = Provider.of<ProductProvider>(context);
    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child:
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Category',style: TextStyle(color: Colors.white,fontSize: 16),),
                  IconButton(onPressed:(){
                    Navigator.pop(context);
                  },
                      icon: Icon(Icons.close,color: Colors.white,))
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: services.category.snapshots(),
            builder: (BuildContext context ,AsyncSnapshot<QuerySnapshot> snapshot){
               if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(),);
              }

              return Expanded(
                child: ListView(
                  shrinkWrap: true,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return ListTile(
                    title: Row(
                      children: [
                        CircleAvatar(
                          minRadius: 22,
                          backgroundImage: NetworkImage(document.get('image')),
                        ),
                        SizedBox(width: 10,),
                        Text(document.get('name'),style: TextStyle(fontSize: 18),),
                      ],
                    ),
                    onTap: (){
                    //  _productProvider.selectCategory(document.get('name'),document.get('image'));
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}


class SubCategoryList extends StatefulWidget {
  @override
  _SubCategoryListState createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  FirebaseServices services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    var _productProvider = Provider.of<ProductProvider>(context);
    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child:
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select SubCategory',style: TextStyle(color: Colors.white,fontSize: 16),),
                  IconButton(onPressed:(){
                    Navigator.pop(context);
                  },
                      icon: Icon(Icons.close,color: Colors.white,))
                ],
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
            //future: services.category.doc(_productProvider.selectedCategory).get(),
            builder: (BuildContext context ,AsyncSnapshot<DocumentSnapshot> snapshot){
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(),);
              }

              Map<String,dynamic>? data = snapshot.data!.data() as Map<String, dynamic>? ;
              return data!=null ? Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Main Category'),
                         // FittedBox(child: Text(_productProvider.selectedCategory,style: TextStyle(fontWeight: FontWeight.bold),)),
                        ],
                      ),
                    ),
                    Divider(thickness: 3,),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: data['subCat']!=null?data['subCat'].length:0,
                            itemBuilder: (BuildContext context , int index){
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text('${index+1}'),),
                                title: Text(data['subCat']!=null ?data['subCat'][index]['name']:''),
                                onTap: (){
                                  //_productProvider.selectSubCategory(data['subCat'][index]['name']);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      )
                  ],
                ),
              ): Text('No Category selected');
            },
          )
        ],
      ),
    );
  }
}

