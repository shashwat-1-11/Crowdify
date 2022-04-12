import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserContributions extends StatefulWidget {
  const UserContributions({Key? key}) : super(key: key);

  @override
  _UserContributionsState createState() => _UserContributionsState();
}

class _UserContributionsState extends State<UserContributions> {
  // bool isLoading = false;
  var currentUser;
  final _database = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void getUserContributions()async{
    try{
      final snaps = await _database.collection('users').doc(currentUser).get();
      if(snaps.exists){
        Map<String, dynamic> data = snaps.data()!;
        print(data['temp']);
      }
    }catch(e){
      print(e);
    }
  }
  void getLoggedinUser()async{
    try{
      final _currentUser = await _auth.currentUser!;
      print(_currentUser.email);
      currentUser = _currentUser.email;
      print('value in variable: $currentUser');
    }catch(e){
      print(e);
    }
  }
  @override
  void initState() {
    getLoggedinUser();
    getUserContributions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xffE6E6E6),
                          Color(0xff14279B),
                        ],
                      )
                  ),
                  height: 170,
                  child: Center(child: Text('My Contributions', style: TextStyle(color: Colors.white, fontSize: 45.0, fontWeight: FontWeight.w900))),
                ),
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
