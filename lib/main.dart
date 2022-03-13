import 'dart:async';

import 'package:beaches_shop/Providers/CouponProvider.dart';
import 'package:beaches_shop/User/Home.dart';
import 'package:beaches_shop/User/HomeScreen.dart';
import 'package:beaches_shop/Login.dart';
import 'package:beaches_shop/Providers/OrderProvider.dart';
import 'package:beaches_shop/Providers/UserProvider.dart';
import 'package:beaches_shop/Providers/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'dart:ui' as ui;

import 'Providers/CartProvider.dart';
import 'SplachScreen.dart';
import 'Providers/VendorViewModel.dart';


void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MediaQuery(
          data: new MediaQueryData.fromWindow(ui.window),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child:MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => UserProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => VendorViewModel(),
                ),
                ChangeNotifierProvider(
                  create: (_) => ProductProvider(),
                ),
                ChangeNotifierProvider(
                    create:(_) => OrderProvider()
                ),
                ChangeNotifierProvider(
                    create:(_) => CartProvider()
                ),

              ],
              child: MyApp(),
              builder: EasyLoading.init(),),
          )
      ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Lato',
          primaryColor: Colors.blue,
          primarySwatch: Colors.grey
      ),
      home: SplachScreen(),
    );
  }
}

