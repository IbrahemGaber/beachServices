
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier{

  String status='';

   filterOrders(status){
     this.status = status;
     notifyListeners();
   }
}