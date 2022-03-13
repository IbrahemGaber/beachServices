
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices{

  User? user = FirebaseAuth.instance.currentUser;
  var category = FirebaseFirestore.instance.collection('Category');
  var product = FirebaseFirestore.instance.collection('Products');
  var vendorBanner = FirebaseFirestore.instance.collection('vendorBanner');
  var vendors = FirebaseFirestore.instance.collection('Vendors');
  var coupons = FirebaseFirestore.instance.collection('Coupons');


  Future<void>publishProduct({id,bool})async{
    return await product.doc(id).update({
      'published': bool
    });
  }

  Future<void>deleteProduct({id})async{
    return await product.doc(id).delete();
  }

  Future<void>saveVendorBanner(bannerImage)async{
    return await vendorBanner.doc().set({
      'BannerImage':bannerImage,
      'sellerUid' : user!.uid
    });
  }

  Future<void>deleteVendorBanner(id)async{
    return await vendorBanner.doc(id).delete();
  }
  Future<DocumentSnapshot>getVendors(id)async{
    return await vendors.doc(id).get();
  }

  Future<void>saveCoupon({title,discountRate,expiry,details,active})async{
    await coupons.doc(title).set({
      'title':title,
      'discountRate':discountRate,
      'expiry':expiry,
      'details':details,
      'active':active,
      'sellerId':user!.uid,
    });
  }
}