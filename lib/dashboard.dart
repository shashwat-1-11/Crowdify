import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'utils/constants.dart';
import 'widgets/registeredEvents.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'widgets/drawer.dart';


class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;
  List event_list = [];
  List user_events = [];
  bool isLoading = false;
  Client ? httpClient;
  Web3Client ? ethClient;
  var currentUser;
  void getEvents() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot<Map<String, dynamic>> events =
        await _database.collection('events').get();
    setState(() {
      event_list = events.docs;
      isLoading = false;
    });
  }
  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot<Map<String, dynamic>> events =
        await _database.collection('users').get();
    setState(() {
      user_events = events.docs;
      isLoading = false;
    });
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
    getEvents();
    // getLoggedinUser();
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ProfileDrawer(),
      backgroundColor: Color(0xffE6E6E6),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: ElevatedButton(
          onPressed: (){
            Navigator.pushNamed(context, '/event');
          },
          child: Text('Register Event', style: TextStyle(fontSize: 20.0)),
            style: ElevatedButton.styleFrom(
              primary: Color(0xff14279B),
              padding: EdgeInsets.symmetric(vertical: 10.0),
            )
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: SafeArea(
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
                  child: Center(child: Text('Crowdify', style: TextStyle(color: Colors.white, fontSize: 45.0, fontWeight: FontWeight.w900))),
                ),
              ),
              SizedBox(height: 30.0),
              isLoading
                  ? Center(
                      child:
                          CircularProgressIndicator(color: Color(0xff14279B)))
                  : ProjectsList(event_list: event_list, ethClient: ethClient),
              ElevatedButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pop(context);
                  },
                  child: Text('Sign Out'))
            ],
          ),
        ),
      ),
    );
  }
}