


import 'package:beaches_shop/Login.dart';
import 'package:beaches_shop/User/HomeScreen.dart';
import 'package:beaches_shop/services/Auth.dart';
import 'package:beaches_shop/services/Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileScreen extends StatefulWidget {
  static const String id = 'profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  User? user = FirebaseAuth.instance.currentUser;
  Services services = Services();
  Auth auth = Auth();
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp){
    });


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
          future: services.getUserData(),
          builder: (context,AsyncSnapshot<DocumentSnapshot>snapShot){
            if(snapShot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            var data = snapShot.data!;
            return Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('حسابي',style: TextStyle(fontSize: 18),)
                        ],),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 2,
                      child: Container(
                        height: 160,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        minRadius: 25,
                                        child: Icon(CupertinoIcons.profile_circled,size: 60,color: Colors.white,),
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(data.get('name'),style: TextStyle(fontSize: 18),),
                                          SizedBox(height: 5,),
                                          Text(data.get('email')),
                                          SizedBox(height: 5,),
                                          Text(data.get('phone')),
                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  ListTile(
                    leading: Icon(Icons.reorder_sharp),
                    title: Text('طلباتي'),
                    onTap: (){
                      Navigator.of(context,rootNavigator:true ).push(MaterialPageRoute(builder: (context)=>HomeScreen(1)));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('تسجيل الخروج'),
                    onTap:  (){
                      auth.signOut();
                      Navigator.of(context,rootNavigator:true ).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
