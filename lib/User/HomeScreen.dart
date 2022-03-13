
import 'package:beaches_shop/Providers/CartProvider.dart';
import 'package:beaches_shop/User/Home.dart';
import 'package:beaches_shop/User/order_screen.dart';
import 'package:beaches_shop/User/profile.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'CartScreen.dart';

class HomeScreen extends StatefulWidget {
  int index=0;
  HomeScreen(this.index);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PersistentTabController? _controller;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: widget.index);
    super.initState();
  }
  List<Widget> _buildScreens() {
    return [
      Home(),
      OrderScreen(),
      ProfileScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("الرئيسية"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.bookmark_border_rounded),
        title: ("الطلبات"),
    activeColorPrimary: Colors.blue,
    inactiveColorPrimary: Colors.grey,
    ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle),
        title: ("الحساب"),
    activeColorPrimary: Colors.blue,
    inactiveColorPrimary: Colors.grey,
    ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Consumer<CartProvider>(
        builder: (context,provider,child){
          return Scaffold(
            appBar: AppBar(
              title: Text('مصيــــفنا',style: TextStyle(fontWeight: FontWeight.bold),),
              centerTitle: true,
              actions:[
                SizedBox(width: 5,),
                IconButton(
                  icon: Icon(Icons.search),iconSize: 25,
                  onPressed: () {  },),
                IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>CartScreen(sellerId: provider.sellerId, total: provider.subTotal,items: provider.cartQty,)));
                  },
                  icon: Icon(Icons.shopping_cart_outlined,),iconSize: 25,),
              ],
            ),
            body: PersistentTabView(
              context,
              controller: _controller,
              screens: _buildScreens(),
              items: _navBarsItems(),
              confineInSafeArea: true,
              backgroundColor: Colors.white, // Default is Colors.white.
              handleAndroidBackButtonPress: true, // Default is true.
              resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: true, // Default is true.
              hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              decoration: NavBarDecoration(),
              screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
            ),
          );
        },
      ),
    );
  }
}
