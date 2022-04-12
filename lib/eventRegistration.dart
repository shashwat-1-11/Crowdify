import 'package:flutter/material.dart';
import 'package:textify/services/functions.dart';
import 'package:textify/utils/constants.dart';
import 'utils/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';




class EventRegistrationPage extends StatefulWidget {
  const EventRegistrationPage({Key? key}) : super(key: key);

  @override
  _EventRegistrationPageState createState() => _EventRegistrationPageState();
}

class _EventRegistrationPageState extends State<EventRegistrationPage> {
  String eventName = '', eventDesc = '', eventKey = '';
  int fundrequired = 0;
  int duration = 0;
  int minFund = 0;
  Client ? httpClient;
  Web3Client ? ethClient;
  bool docExist = true;
  bool showSpinner = false;
  bool idCheckSpinner = false;
  bool docid_checked = false;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Color(0xff14279B),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30.0, bottom: 30.0),
                  height: 235.0,
                  decoration: BoxDecoration(
                      color: Color(0xffE6E6E6),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0)),
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xff14279B),
                          Color(0xffE6E6E6),
                        ],
                      )
                  ),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Event \nRegistration', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w900))
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Event Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                        TextField(
                          onChanged: (val){
                            eventName = val;
                          },
                          maxLines: null,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          decoration: customBoxStyle,
                        ),
                        SizedBox(height: 15.0),
                        Text('Event Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                        TextField(
                          onChanged: (val){
                            eventDesc = val;
                          },
                          maxLines: null,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          decoration: customBoxStyle,
                        ),
                        SizedBox(height: 15.0),
                        Text('Fund Required', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                        TextField(
                          onChanged: (val){
                            fundrequired = int.parse(val);
                          },
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          maxLines: null,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          decoration: customBoxStyle,
                        ),
                        SizedBox(height: 15.0),
                        Text('Minimum Fund', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                        TextField(
                          onChanged: (val){
                            minFund = int.parse(val);
                          },
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          maxLines: null,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          decoration: customBoxStyle,
                        ),
                        SizedBox(height: 15.0),
                        Text('Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                        TextField(
                          onChanged: (val){
                            duration = int.parse(val);
                          },
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          decoration: customBoxStyle,
                        ),
                        SizedBox(height: 15.0),
                        Text('Event Key', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                        TextField(
                          onChanged: (val) async {
                            setState(() {
                              docid_checked = false;
                              eventKey = val;
                            });
                          },
                          maxLines: null,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          decoration: customBoxStyle,
                        ),
                        Center(
                          child: idCheckSpinner ? CircularProgressIndicator(color: Color(0xff14279B)) : null,
                        ),
                        Center(
                          child: Visibility(
                            visible: docid_checked,
                              child: docExist ? Text('choose another doc id', style: TextStyle(color: Colors.red)) :
                              Text('id avaialable', style: TextStyle(color: Colors.green))
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: ElevatedButton(
                                onPressed: eventKey == '' ? null : () async {
                                  setState(() {
                                    idCheckSpinner = true;
                                  });
                                  bool _docExist = await checkIfDocExists(eventKey);
                                  print(_docExist.toString());
                                  setState((){
                                    idCheckSpinner = false;
                                    docExist = _docExist;
                                    docid_checked = true;
                                  });
                                },
                                child: Text('Check key availability'),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff14279B),
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                )
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ElevatedButton(
                                onPressed: docid_checked && !docExist ? () async {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  await registerEvent(eventName, ethClient!);
                                  await setData(fundrequired, minFund, duration, ethClient!);
                                  await _firestore.collection('events').doc(eventKey).set({
                                    'eventName' : eventName,
                                    'description' : eventDesc,
                                    'fundRequired' : fundrequired,
                                    'fundRaised' : 0,
                                    'duration' : duration,
                                    'key' : eventKey,
                                    'minFund' : minFund,
                                    'status' : 'running'
                                  }).then((_) => print('event created')).catchError((e) => print(e));

                                  Navigator.pushNamed(context, '/dashboard');
                                  setState(() {
                                    showSpinner = false;
                                  });

                                } : null,
                                child: Text('Submit', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xff14279B),
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                              )
                            ),
                          ),
                        )
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
  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = _firestore.collection('events');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }
}