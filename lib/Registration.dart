import 'package:beaches_shop/Providers/UserProvider.dart';
import 'package:beaches_shop/Vendor/Vendorhome.dart';
import 'package:beaches_shop/services/Auth.dart';
import 'package:beaches_shop/services/Services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'User/HomeScreen.dart';
import 'customPaint/form.dart';
import 'customPaint/logo.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  late UserProvider userProvider;
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameTextEdit = TextEditingController();
  TextEditingController lastNameTextEdit = TextEditingController();
  TextEditingController addressTextEdit = TextEditingController();
  TextEditingController phoneTextEdit = TextEditingController();
  TextEditingController emailTextEdit = TextEditingController();
  TextEditingController password = TextEditingController();
  Auth auth = Auth();
  Services services = Services();

  static late String type;
  bool loading = false;


  List<String> accountType = [
    'بائع',
    'زبون',
  ];
  late String dropdownValue;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      userProvider=Provider.of(context,listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20,right: 20),
                          child: Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height *0.78,
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
                                        Padding(
                                          padding: const EdgeInsets.only(top:20),
                                          child: Text(
                                            'انشاء حساب جديد',
                                            style: TextStyle(
                                                fontSize: 28, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 35,
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8, bottom: 8),
                                          child: TextFormField(
                                            controller: firstNameTextEdit,
                                            validator: (value){
                                              if(value!.isEmpty){
                                                return 'ادخل الاسم الاول';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                               // prefixIcon: Icon(Icons.email_outlined),
                                                hintText: 'ادخل الاسم الاول',
                                                hintStyle: TextStyle(color: Colors.grey)),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8, bottom: 8),
                                          child: TextFormField(
                                            controller: lastNameTextEdit,
                                            validator: (value){
                                              if(value!.isEmpty){
                                                return 'ادخل اسم العائلة';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                               // prefixIcon: Icon(Icons.email_outlined),
                                                hintText: 'ادخل اسم العائلة',
                                                hintStyle: TextStyle(color: Colors.grey)),
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
                                                //prefixIcon: Icon(Icons.email_outlined),
                                                hintText: 'ادخل البريد الالكتروني',
                                                hintStyle: TextStyle(color: Colors.grey)),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8, bottom: 8),
                                          child: TextFormField(
                                            controller: addressTextEdit,
                                            validator: (value){
                                              if(value!.isEmpty){
                                                return 'ادخل العنوان';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                hintText: 'ادخل العنوان ',
                                                hintStyle: TextStyle(color: Colors.grey)),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8, bottom: 8),
                                          child: TextFormField(
                                            controller: phoneTextEdit,
                                            validator: (value){
                                              if(value!.isEmpty){
                                                return 'ادخل رقم الهاتف';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                hintText: 'ادخل رقم الهاتف ',
                                                hintStyle: TextStyle(color: Colors.grey)),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 8, bottom: 8),
                                          child: DropdownButtonFormField<String>(
                                            validator: (value){
                                              if(value!.isEmpty){
                                                return 'اختار نوع الحساب';
                                              }
                                              return null;
                                            },

                                            hint: Text(
                                              'اختر نوع الحساب',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(right: 4,top: 5,bottom: 5)),
                                            icon: Icon(Icons.arrow_drop_down),
                                            onChanged: (value) {
                                              setState(() {
                                                dropdownValue = value!;
                                                if (dropdownValue == 'بائع') {
                                                  type = 'employee';
                                                } else if (dropdownValue == 'عميل') {
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
                                               // prefixIcon: Icon(Icons.lock_clock_outlined),
                                                hintText: 'ادخل كلمة المرور',
                                                hintStyle: TextStyle(color: Colors.grey)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50, right: 50),
                                                child:Consumer<UserProvider>(
                                                  builder:(context,provider,child){
                                                    return  TextButton(
                                                      onPressed: () async {
                                                        if(_formKey.currentState!.validate()){
                                                          setState(() {
                                                            loading = true;
                                                          });
                                                          if(dropdownValue=='بائع'){
                                                            auth.createUser(emailTextEdit.text, password.text).then((value)async{
                                                              await services.addVendor(
                                                                "${firstNameTextEdit.text} ${lastNameTextEdit.text}",
                                                                emailTextEdit.text,
                                                                addressTextEdit.text,
                                                                phoneTextEdit.text,
                                                                dropdownValue,
                                                                value!.user!.uid,);
                                                              Navigator.pushReplacement(context,
                                                                  MaterialPageRoute(builder:(BuildContext context)=>VendorHome())
                                                              );
                                                              loading = false;
                                                              await provider.getVendor();
                                                            });
                                                          }
                                                          else{
                                                            auth.createUser(emailTextEdit.text, password.text).then((value)async{
                                                              await services.addUser(
                                                                "${firstNameTextEdit.text} ${lastNameTextEdit.text}",
                                                                emailTextEdit.text,
                                                                addressTextEdit.text,
                                                                phoneTextEdit.text,
                                                                dropdownValue,
                                                                value!.user!.uid,);
                                                              Navigator.pushReplacement(context,
                                                                  MaterialPageRoute(builder:(BuildContext context)=>HomeScreen(0))
                                                              );
                                                              loading = false;
                                                             await provider.getUser();
                                                            });
                                                          }


                                                        }
                                                      },
                                                      child: loading
                                                          ?Center(child: Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: CircularProgressIndicator(backgroundColor: Colors.white,),
                                                      ),)
                                                          :Text(
                                                        ' انشاء ',
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
                                                  })

                                                ),
                                              ),
                                          ],
                                        ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
