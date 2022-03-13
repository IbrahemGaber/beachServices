
import 'dart:async';

import 'package:beaches_shop/User/HomeScreen.dart';
import 'package:beaches_shop/Providers/UserProvider.dart';
import 'package:beaches_shop/Vendor/Vendorhome.dart';
import 'package:beaches_shop/services/Services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'User/Home.dart';
import 'Login.dart';

class SplachScreen extends StatefulWidget {
  @override
  _SplachScreenState createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  UserProvider? userProvider;
  User? user = FirebaseAuth.instance.currentUser;
  Services services = Services();
  String? vendor;
  String? userr;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async{
      final prefs = await SharedPreferences.getInstance();
      userProvider = Provider.of(context,listen: false);
      userProvider!.getUser();
      userProvider!.getVendor();

      userr=prefs.get('user') as String?;
      vendor=prefs.get('vendor') as String?;
      print("fsdfds$vendor");

      Timer(Duration(milliseconds: 3000), (){
        user!=null&&userr=='زبون'?
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(0)))
        :user!=null&&vendor=='بائع'?
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>VendorHome()))
            :Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
                width: 300,
                height: 250,
                child: Image.asset('assets/beach.png'),
              )
            ],),
          ),
        ));
  }
}
