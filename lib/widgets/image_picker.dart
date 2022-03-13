
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/auth_provider.dart';



class ShopImage extends StatefulWidget {
  @override
  _ShopImageState createState() => _ShopImageState();
}

class _ShopImageState extends State<ShopImage> {
  File? _image;
  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: (){
          authProvider.getImage().then((image){
            setState(() {
              _image = image;
            });
            if(image!=null){
              authProvider.isPicAvail = true;
            }
          });
        },
        child: SizedBox(
          height: 150,
          width: 150,
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Center(child:
                _image == null
                  ?Text('Add Shop Image',
                   style: TextStyle(color: Colors.grey),)
                  : Container(
                child: Image.file(_image!,fit:BoxFit.fill,),
              ),),
            ),
          ),
        ),
      ),
    );
  }
}
