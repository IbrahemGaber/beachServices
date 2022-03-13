import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider extends ChangeNotifier {
  var product = FirebaseFirestore.instance.collection('Products');
  File? image;
  String? pickerError = '';
  var productImage;



  Future<File?> getProductImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickerFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickerFile != null) {
      this.image = File(pickerFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected';
      print('No image selected');
      notifyListeners();
    }
    return this.image;
  }

  Future uploadFile(filePath, productName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;

    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('productImage/$productName$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }

    String downloadURL = await _storage
        .ref('productImage/$productName$timeStamp')
        .getDownloadURL();
    this.productImage = downloadURL;
    notifyListeners();
    return downloadURL;
  }

  Future<void> saveProductData(
      {context,
      productName,
      productImage,
      desciption,
      price,
      comapredPrice,
      brand,
      sku,
      tax,
      }) async {
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await product.doc(timeStamp.toString()).set({
        'seller':  user!.uid,
        'productName': productName,
        'productImage': this.productImage,
        'description': desciption,
        'price': price,
        'comparedPrice': comapredPrice,
        'brand': brand,
        'sku': sku,
        'tax': tax,
        'published': false,
        'productID': timeStamp.toString()
      });
      this.alertDialog(
          context: context,
          title: ' حفظ',
          content: 'تم حفظ البيانات بنجاح');
    } catch (e) {
      this.alertDialog(
          context: context, title: 'حفظ', content: '${e.toString()}');
    }
    return null;
  }

  Future<void> updateProducts(
      {context,
        productId,
        productName,
        productImage,
        desciption,
        price,
        comapredPrice,
        brand,
        sku,
        tax,

      }) async {
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await product.doc(productId).update({
        'productName': productName,
        'productImage': this.productImage == null ? productImage :this.productImage,
        'description': desciption,
        'price': price,
        'comparedPrice': comapredPrice,
        'brand': brand,
        'sku': sku,
        'tax': tax,

      });
      this.alertDialog(
          context: context,
          title: ' حفظ',
          content: 'تم حفظ البيانات بنجاح');
    } catch (e) {
      this.alertDialog(
          context: context, title: 'حفظ', content: '${e.toString()}');
    }
    return null;
  }

  alertDialog({context, title, content}) {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('موافق'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
