import 'package:flutter/material.dart';
import 'homePage.dart';
import 'loginPage.dart';
import 'registrationPage.dart';
import 'dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'test/testotp.dart';
import 'eventRegistration.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff14279B)),
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => HomePage(),
        '/login' : (context) => LoginPage(),
        '/register' : (context) => RegistrationPage(),
        '/dashboard' : (context) => DashBoard(),
        '/event' : (context) => EventRegistrationPage()
      },
    );
  }
}
