import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/components.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

String phoneNo = '';
String name = '';
String username = '';
String password = '';
bool formCompleted = false;

class _SignUpPageState extends State<SignUpPage> {
  void validateForm (){
    if(phoneNo.length == 10 && name.length != 0 && username.length != 0 && password.length > 5){
      formCompleted =true;
    }else{
      formCompleted = false;
    }
  }
  bool signupObscure = true;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeadClipper(),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mobile Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                    TextField(
                      onChanged: (val){
                        phoneNo = val;
                        setState(() {validateForm();});
                      },
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.phone,
                      decoration: customBoxStyle,
                    ),
                    SizedBox(height: 15.0),
                    Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                    TextField(
                      onChanged: (val){
                        name = val;
                        setState(() {validateForm();});
                      },
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      decoration: customBoxStyle,
                    ),
                    SizedBox(height: 15.0),
                    Text('Username', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                    TextField(
                      onChanged: (val){
                        username = val;
                        setState(() {validateForm();});
                      },
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      decoration: customBoxStyle,
                    ),
                    SizedBox(height: 15.0),
                    Text('Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                    TextField(
                      onChanged: (val){
                        password = val;
                        setState(() {validateForm();});
                      },
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      obscureText: signupObscure,
                      decoration: customBoxStyle.copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye, color: Colors.grey),
                          onPressed: (){
                            setState(() {
                              signupObscure = signupObscure == true ? false : true;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    GestureDetector(
                      onTap: () {
                        formCompleted == true ? Navigator.pushNamed(context, '/dashboard') : null;
                        phoneNo = '+91' + phoneNo;
                        // formCompleted == true ? phoneSignIn(phoneNumber: phoneNo) : null;
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        margin: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('Sign up', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                        decoration: BoxDecoration(
                            color: formCompleted ? Color(0xff14279B) : Color(0xff14279B).withOpacity(0.5)
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
