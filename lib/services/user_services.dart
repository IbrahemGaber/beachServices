import 'package:cloud_firestore/cloud_firestore.dart';


class UserServ{

  String userCollection = 'User';
  FirebaseFirestore  _firestore = FirebaseFirestore.instance;

  //createUser
 Future<void> createUserData(Map<String,dynamic> values) async {

   String id = values['id'];
   await _firestore.collection(userCollection).doc(id).set(values);
  }

  //updateUser
Future<void> updateUserData(Map<String,dynamic> values) async{
   String id = values['id'];
   await _firestore.collection(userCollection).doc(id).update(values);
}

//get User
Future<DocumentSnapshot> getUserData(String id) async {
   var result = _firestore.collection(userCollection).doc(id).get();

   return result;
}

Future<void>updateUser(userId,firstName,lastName,number,email)async{
  await _firestore.collection(userCollection).doc(userId).update({
    'number': number,
    'firstName': firstName,
    'lastName':lastName,
    'email':email
  });
}

}