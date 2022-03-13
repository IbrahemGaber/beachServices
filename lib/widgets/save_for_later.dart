
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SaveForLater extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  SaveForLater(this.documentSnapshot);
  @override
  _SaveForLaterState createState() => _SaveForLaterState();
}

class _SaveForLaterState extends State<SaveForLater> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        EasyLoading.show(status: 'حفظ..');
        saveForLater().then((value) =>{
          EasyLoading.showSuccess('تم الحفظ')
        });
      },
      child: Container(
        height: 56,
        color: Colors.grey[800],
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark,color: Colors.white,),
                  SizedBox(width: 5,),
                  Text('حفظ في وقت اخر',style: TextStyle(color: Colors.white),)
                ],
              )
          ),
        ),
      ),
    );
  }
  Future<void>saveForLater()async{
    CollectionReference favourite = FirebaseFirestore.instance.collection('Favourites');
    User? user = FirebaseAuth.instance.currentUser;
      favourite.add({
      'product':widget.documentSnapshot.data(),
      'customerId':user!.uid,
    });
  }
}
