import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffE6E6E6),
                  Color(0xff14279B)
                ],
              )
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('CROWD', style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w900, color: Colors.white)),
                  Text('IFY', style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w900, color: Colors.black))
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/login');
                },
                child: Container(
                  alignment: Alignment.center,
                    child: Text('Login', style: TextStyle(fontSize: 20.0)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50.0))
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  width: MediaQuery.of(context).size.width * 0.8,
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(50.0))
                  ),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    child: Text('Register', style: TextStyle(fontSize: 20.0, color: Colors.white))
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/register');
                })
            ],
          ),
        ),
      ),
    );
  }
}
