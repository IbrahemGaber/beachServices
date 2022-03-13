import 'package:beaches_shop/Vendor/order_screen.dart';
import 'package:beaches_shop/Vendor/productScreen.dart';
import 'package:flutter/material.dart';

import 'Auth.dart';

class DrawerServices{
  Auth auth = Auth();


  Widget? drawerScreen(title){


    if(title == 'المنتاجات'){
      return ProductScreen();
    }


    if(title == 'الطلبات'){
      return OrderScreen();
    }

    return ProductScreen();
}
}