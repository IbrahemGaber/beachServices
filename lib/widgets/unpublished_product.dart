

import 'package:beaches_shop/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UnpublishedProducts extends StatefulWidget {
  @override
  _UnpublishedProductsState createState() => _UnpublishedProductsState();
}

class _UnpublishedProductsState extends State<UnpublishedProducts> {
  FirebaseServices services =FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: services.product.where('published',isEqualTo: false).snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text('Something error');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }

          return SingleChildScrollView(
            child: FittedBox(
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 60,
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                columns: <DataColumn>[
                  DataColumn(label: Expanded(child: Text('المنتج'))),
                  DataColumn(label: Text('الصوره')),
                  DataColumn(label: Text('الوصف')),
                  DataColumn(label: Text('التحكم')),
                ], rows: productDetails(snapshot.data,context),
              ),
            ),
          );
      },
      ),
    );
  }

  List<DataRow>productDetails(snapshot,context){
    List<DataRow> newList = snapshot.docs.map<DataRow>((document){
        return DataRow(
            cells:[
              DataCell(Container(child: Text(document.get('productName'))),),
              DataCell(Row(children: [Container(child: Image.network(document.get('productImage'),width: 50,),)],)),
              DataCell(
                  IconButton(
                    onPressed:(){
                      //Navigator.push(context, MaterialPageRoute(builder:(context)=>EditViewProduct(productId:document.get('productID'))));
                      } ,
                    icon:Icon(Icons.info_outline) ,
              )),
              DataCell(
                popUpButton(document.data())
              ),
            ] );
    }).toList();
    return newList;
  }
  Widget popUpButton(data,{BuildContext? context}){
    return PopupMenuButton<String>(
      onSelected: (value){
        print(value);
        if(value == 'publish'){
            services.publishProduct(id:data['productID'],bool: true);
        }
        if(value == 'delete'){

          services.deleteProduct(id:data['productID']);

        }
      },
        itemBuilder:(BuildContext context)=>[
          const PopupMenuItem<String>(
            value: 'publish',
            child: ListTile(
              leading: Icon(Icons.check),
            title: Text('Publish'),),
          ),

          const PopupMenuItem<String>(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),),
          )
        ]);
  }
}
