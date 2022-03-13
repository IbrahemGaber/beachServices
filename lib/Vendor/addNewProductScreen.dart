

import 'dart:io';
import 'package:beaches_shop/widgets/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../Providers/product_provider.dart';

class AddNewProductScreen extends StatefulWidget {
  static const String id = 'addProduct_screen';
  @override
  _AddNewProductScreenState createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {


  List<String> _collection = [
    'Featured Product',
    'Best Selling',
    'Recently Add'
  ];
 late String dropdownValue ;
  var comparedPriceEditText = TextEditingController();
  var productBrandEditText = TextEditingController();

  File? _image;
  bool? _visible=false;
  bool _track = false;

  String? productName;
  String? productDescription;
  double? productPrice;
  String? productBrand;
  String? sku;
  String? weight;
  double? tax;

 @override
  void initState() {
    dropdownValue = _collection[0];
    super.initState();
  }

  var _keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    var _productProvider = Provider.of<ProductProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: Form(
          key:_keyForm,
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
                        child: Text('المنتجات / اضافة'),
                      ),
                      SizedBox(width: 10,),
                      TextButton(
                        onPressed:(){
                          if(_keyForm.currentState!.validate()){
                                if(_image!=null){

                                  EasyLoading.show(status: 'حفظ..');

                                  _productProvider.uploadFile(_image!.path, productName).then((url) {
                                    if(url!=null){
                                      //update data to db
                                      EasyLoading.dismiss();

                                      _productProvider.saveProductData(
                                          context: context,
                                          productName: productName,
                                          desciption: productDescription,
                                          price: productPrice.toString(),
                                          comapredPrice: comparedPriceEditText.text,
                                          brand: productBrandEditText.text,
                                          sku: sku,
                                          tax: tax.toString(),

                                      );

                                      setState(() {
                                        _keyForm.currentState!.reset();
                                        comparedPriceEditText.clear();
                                        productBrand = '';
                                        _image =null;
                                        _track=false;

                                      });

                                    }else{
                                      _productProvider.alertDialog(
                                          context:context,
                                          title:' تنزيل',
                                          content:'  خطا في تنزيل الصوره'
                                      );
                                    }
                                  });
                                }else{
                                  _productProvider.alertDialog(
                                      context: context,
                                      title:'لم يتم اختيار الصوره ',
                                      content:'لم يتم اختيار الصوره'
                                  );
                                }
                              }

                          },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('حفظ',style: TextStyle(color: Colors.white),),
                            Icon(Icons.save,color: Colors.white,),
                          ],
                        ),

                        style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),)
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'ادخل اسم المنتج';
                                    }
                                    setState(() {
                                      productName = value;
                                    });

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                    labelText: ' اسم المنتج',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey
                                      )
                                    )
                                  ),
                                ),
                                TextFormField(
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return ' وصف المنتج';
                                    }
                                    setState(() {
                                      productDescription = value;
                                    });

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                      labelText: ' وصف المنتج',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                          )
                                      )
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      _productProvider.getProductImage().then((value){
                                        _image =value;
                                      });
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Card(
                                        child: Center(
                                          child:_image==null?Text(' اختار صورة') : Image.file(_image!,fit: BoxFit.cover,),),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'ادخل السعر';
                                    }
                                    setState(() {
                                      productPrice = double.parse(value);
                                    });

                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                      labelText: 'السعر',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                          )
                                      )
                                  ),
                                ),
                                TextFormField(
                                  controller: comparedPriceEditText,
                                  validator: (value){
                                    if(value!.isEmpty) {
                                      if (productPrice! >
                                          double.parse(value)) {
                                        return 'يجب ان يكون السعر اقل من السعر القديم';
                                      }
                                    }

                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                      labelText: 'السعر القديم',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                          )
                                      )
                                  ),
                                ),
                                TextFormField(
                                  controller: productBrandEditText,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'الماركة ادخل ';
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                      labelText: 'الماركة',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                          )
                                      )
                                  ),
                                ),
                                TextFormField(
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'ادخل الكود الخاص بالمنتج';
                                    }
                                    setState(() {
                                      sku = value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                      labelText: 'الكود',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                          )
                                      )
                                  ),
                                ),
                                TextFormField(
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'ادخل الخدمه المضافه';
                                    }
                                    setState(() {
                                      tax =double.parse(value);
                                    });
                                    return null ;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(),
                                      labelText: 'الخدمه % ',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                          )
                                      )
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
