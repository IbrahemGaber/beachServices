
import 'package:beaches_shop/Providers/UserProvider.dart';
import 'package:beaches_shop/Registration.dart';
import 'package:beaches_shop/Vendor/Vendorhome.dart';
import 'package:beaches_shop/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'User/HomeScreen.dart';
import 'customPaint/form.dart';
import 'customPaint/logo.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late UserProvider userProvider;
  Auth auth = Auth();
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailTextEdit = TextEditingController();
  TextEditingController password = TextEditingController();

  static late String type;


  List<String> accountType = [
    'بائع',
    'زبون',
  ];
  late String dropdownValue;

  @override
  void initState() {
    userProvider = Provider.of(context,listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: CustomPaint(
                    size: Size(
                        MediaQuery.of(context).size.width,
                        (MediaQuery.of(context).size.width * 0.5)
                            .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                    painter: RPSCustomPainter(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height *0.65,
                        child: CustomPaint(
                          size: Size(
                              MediaQuery.of(context).size.width,
                              (MediaQuery.of(context).size.width * 0.99)
                                  .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                          painter: RPSFormCustomPainter(),
                        ),
                      ),
                      Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 50, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'تسجيل دخول',
                                  style: TextStyle(
                                      fontSize: 28, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(top: 8, bottom: 8),
                                  child: DropdownButtonFormField<String>(
                                    validator: (value){
                                      if(value == null){
                                        return 'اختار نوع الحساب';
                                      }
                                      return null;
                                    },

                                    hint: Text(
                                      'اختر نوع الحساب',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(right: 35,top: 5,bottom: 5)),
                                    icon: Icon(Icons.arrow_drop_down),
                                    onChanged: (value) {
                                      setState(() {
                                        dropdownValue = value!;
                                        if (dropdownValue == 'عامل') {
                                          type = 'employee';
                                        } else if (dropdownValue == 'مشرف') {
                                          type = 'supervisor';
                                        }
                                      });
                                      print(dropdownValue);
                                    },
                                    items: accountType
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                              value: value,
                                              child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: FittedBox(child: Text(value,style: TextStyle(),))));
                                        }).toList(),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(top: 8, bottom: 8),
                                  child: TextFormField(
                                    controller: emailTextEdit,
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'ادخل الايميل';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email_outlined),
                                        hintText: 'ادخل البريد الالكتروني',
                                        hintStyle: TextStyle(color: Colors.grey)),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 8, top: 8),
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: password,
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'ادخل الباسورد';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon:
                                        Icon(Icons.lock_clock_outlined),
                                        hintText: 'ادخل كلمة المرور',
                                        hintStyle: TextStyle(color: Colors.grey)),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50, right: 50),
                                        child:  Consumer<UserProvider>(
                                          builder: (context,provider,child){
                                            return TextButton(
                                              onPressed: () async {
                                                if(_formKey.currentState!.validate()){
                                                  if(dropdownValue=='بائع'){
                                                    auth.signIn(emailTextEdit.text, password.text).then((value)async{
                                                      if(value!=null){
                                                        Navigator.pushReplacement(context,
                                                            MaterialPageRoute(builder:(BuildContext context)=>VendorHome()));
                                                            await provider.getVendor();
                                                      }else{
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text("خطا في ادخال الايميل او الباسورد",textAlign: TextAlign.end,),));
                                                      }
                                                    });
                                                  }
                                                  else{
                                                    auth.signIn(emailTextEdit.text, password.text).then((value)async{
                                                      if(value!=null){
                                                        Navigator.pushReplacement(context,
                                                            MaterialPageRoute(builder:(BuildContext context)=>HomeScreen(0)));
                                                       await provider.getUser();
                                                      }else{
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text("خطا في ادخال الايميل او الباسورد",textAlign: TextAlign.end,),));
                                                      }
                                                    });
                                                  }

                                                }
                                              },
                                              child: Text(
                                                'تسجيل دخول',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              style: TextButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                                  backgroundColor:
                                                  Theme.of(context)
                                                      .primaryColor),
                                            );
                                          },

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text('ليس لديك حساب؟'),
                                    SizedBox(width: 5,),
                                    InkWell(
                                        child: Text('انشاء حساب',style: TextStyle(color: Colors.blue),),
                                      onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Registration()));
                                    },),
                                  ],)
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
