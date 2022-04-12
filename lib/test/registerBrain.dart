import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ElevatedButton(
          child: Text('Demo Sign up'),
          onPressed: (){
            phoneSignIn(phoneNumber: '+911234567890');
          },
        ),
      ),
    );
  }
  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(minutes: 2),
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }
  TextEditingController otpCode = TextEditingController();
  bool isLoading = false;
  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      this.otpCode.text = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try{
        UserCredential credential = await user!.linkWithCredential(authCredential);
      }on FirebaseAuthException catch(e){
        if(e.code == 'provider-already-linked'){
          await _auth.signInWithCredential(authCredential);
        }
      }
      setState(() {
        isLoading = false;
      });
      // Navigator.pushNamedAndRemoveUntil(context, Constants.homeNavigate, (route) => false);
      await FirebaseAuth.instance.signInWithCredential(authCredential);
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }
  }
  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      print("The phone number entered is invalid!");
    }
  }
  // String userOtp = '';
  String verificationId = '';
  _onCodeSent(String verificationId, int? forceResendingToken) {
    verificationId = this.verificationId;
    print(forceResendingToken);
    print("code sent - $verificationId");
    otpDialogBox(context).then((value) {});
  }
  Future<void> signIn(String otp) async {
    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      await FirebaseAuth.instance.signInWithCredential(credential);
      invalidOtp = false;
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    }catch (e){
      print('Otp mismatch');
      setState(() {
        invalidOtp = true;
      });
      print(e);
    }

  }
  String otp = '';
  bool invalidOtp = false;
  otpDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter your OTP'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)))),
                    onChanged: (value) {
                      if(value.length==0){
                        setState(() {
                          invalidOtp = false;
                        });
                      }
                      otp = value;
                    },
                  ),
                  Visibility(
                      visible: invalidOtp,
                      child: Text('Incorrect OTP entered!', style: TextStyle(color: Colors.red))
                  )
                ],
              ),

            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  signIn(otp);
                },
                child: Text('Submit'),
              ),
            ],
          );
        });
  }
  _onCodeTimeout(String timeout) {
    return null;
  }
}



