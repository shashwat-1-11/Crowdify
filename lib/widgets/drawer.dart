import 'package:flutter/material.dart';
import 'package:textify/userContributions.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('User Profile'),
              )
          ),
          ListTile(
            title: Text('My Contributions'),
            enabled: true,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserContributions()));
            },
          ),
          ListTile(
            title: Text('My Events'),
          ),
          ListTile(
            title: Text('Sign Out'),
          )
        ],
      ),
    );
  }
}
