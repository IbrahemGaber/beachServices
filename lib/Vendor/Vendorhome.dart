
import 'package:beaches_shop/services/drawer_services.dart';
import 'package:beaches_shop/widgets/drawer_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';



class VendorHome extends StatefulWidget {
  
  static const String id = 'home_screen';

  @override
  _VendorHomeState createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {

  DrawerServices services = DrawerServices();


  GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  late String title='';


  @override
  Widget build(BuildContext context) {
    Widget? widget = services.drawerScreen(title);
    return Scaffold(
      body: SliderDrawer(
        slideDirection: SlideDirection.RIGHT_TO_LEFT,
          isDraggable: true,
          appBar: SliderAppBar(
              appBarColor: Colors.white,
              title: Text('',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w700))),
          key: _key,
          sliderOpenSize: 250,
          slider: MenuWidget(
            onItemClick: (title) {
              _key.currentState!.closeSlider();
              setState(() {
                this.title=title;
              });
            },
          ),

          child: widget!=null ? widget : Container()
      ),
    );
  }
}
