import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class EventPage extends StatefulWidget {
  final Web3Client ethClient;
  final eventData;
  const EventPage({Key? key, required this.ethClient, required this.eventData}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

TextStyle descText = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey);

class _EventPageState extends State<EventPage> {
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
                  height: 170,
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
                  child: Center(child: Text(widget.eventData['eventName'],
                      style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.w900))
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Project Description',
                        style: TextStyle(fontSize: 25.0, color: Color(0xff14279B), fontWeight: FontWeight.w900)
                    ),
                    SizedBox(height: 8.0),
                    Text('Event Description: ${widget.eventData['description']}', style: descText, textAlign: TextAlign.justify),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(widget.eventData['fundRaised'].toString(),
                              style: TextStyle(fontSize: 50.0, color: Color(0xff14279B), fontWeight: FontWeight.w900),
                            ),
                            Text('Total Fund \nRaised', style: descText, textAlign: TextAlign.center)
                          ],
                        ),
                        // SizedBox(width: 2.0),
                        Column(
                          children: [
                            Text(widget.eventData['minFund'].toString(),
                              style: TextStyle(fontSize: 50.0, color: Color(0xff14279B), fontWeight: FontWeight.w900),
                            ),
                            Text('Min Fund \nRequired', style: descText, textAlign: TextAlign.center)
                          ],
                        ),
                        // SizedBox(width: 2.0),
                        Column(
                          children: [
                            Text(widget.eventData['fundRequired'].toString(),
                              style: TextStyle(fontSize: 50.0, color: Color(0xff14279B), fontWeight: FontWeight.w900),
                            ),
                            Text('Total Fund \nNeeeded', style: descText, textAlign: TextAlign.center)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                    onPressed: (){},
                    child: Text('Conrtibute', style: TextStyle(fontSize: 20.0),),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff14279B),
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
