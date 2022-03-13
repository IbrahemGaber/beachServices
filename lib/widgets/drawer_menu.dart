
import 'package:beaches_shop/services/Auth.dart';
import 'package:beaches_shop/services/Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login.dart';
import '../Providers/VendorViewModel.dart';

class MenuWidget extends StatefulWidget {
  final Function(String)? onItemClick;

  const MenuWidget({Key? key, this.onItemClick}) : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {

  late VendorViewModel vendorViewModel;
  User? _user = FirebaseAuth.instance.currentUser;
  Auth auth = Auth();
  Services services = Services();


  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      vendorViewModel = Provider.of(context,listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FutureBuilder<DocumentSnapshot>(
        future: services.getVendorData(),
        builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot>snapShot){
          if(snapShot.hasError){
            return Text('Error');
          }
          if(snapShot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          snapShot.data!.get('name');
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Consumer<VendorViewModel>(
                    builder: (context,provider,child){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 37,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                              radius: 35,
                              //backgroundImage: NetworkImage(provider.url),
                            ),
                          ),
                        ],

                      );
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text(
                    snapShot.data!.get('name'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'BalsamiqSans'),
                  ),
                ),
                Center(
                  child: Text(
                    snapShot.data!.get('email'),
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontFamily: 'BalsamiqSans'),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                sliderItem('المنتاجات', Icons.shopping_bag_outlined),
                sliderItem('الطلبات', Icons.list_alt_outlined),
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Row(
                    children: [
                      IconButton(onPressed:()async{
                        final prefs = await SharedPreferences.getInstance();
                        auth.signOut();
                        prefs.setString('user','');
                        prefs.setString('vendor','');
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
                      },
                          icon: Icon(Icons.exit_to_app,color:Colors.black54,size: 25)),
                      Text('تسجيل الخروج',style: TextStyle(fontSize: 16))
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget sliderItem(String title, IconData icons) => InkWell(
    child: Padding(
      padding: const EdgeInsets.only(left: 4,right: 4, ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          child: SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  Icon(icons,color: Colors.black54,size: 25,),
                  SizedBox(width: 10,),
                  Text(title,style: TextStyle(fontSize: 16),)
                ],
              ),
            ),
          ),
        ),
      ),
    ),
      onTap: () {
        widget.onItemClick!(title);
      });
}