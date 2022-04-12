import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:textify/eventPage.dart';

class ProjectsList extends StatelessWidget {
  const ProjectsList({Key? key, required this.event_list, required this.ethClient,}) : super(key: key);

  final List event_list;
  final Web3Client? ethClient;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: event_list.length,
        itemBuilder: (BuildContext context, int index) {
          if (event_list.length == 0) {
            return Icon(Icons.refresh);
          }
          return Card(
            elevation: 10.0,
            shadowColor: Color(0xff14279B),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(
                  color: Color(0xff14279B), width: 2.0),
            ),
            margin: EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 8.0),
            color: Color(0xffE6E6E6),
            child: ListTile(
              enabled: true,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => EventPage(ethClient: ethClient!, eventData: event_list[index])));
              },
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(event_list[index]['eventName'], style: eventTitle),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${event_list[index]['status']}', style: eventDesc),
                    Text('Total Fund Raised: ${event_list[index]['fundRequired']} ethers', style: eventDesc),
                    Text('Total Fund Requirement: ${event_list[index]['fundRequired']} ethers', style: eventDesc)
                  ],
                ),
              ),
            ),
          );
        });
  }
}

TextStyle eventTitle = TextStyle(fontWeight: FontWeight.w900, fontSize: 24.0);
TextStyle eventDesc = TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0);