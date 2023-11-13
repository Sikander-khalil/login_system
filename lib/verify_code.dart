import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_firebase/welcome_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
final String verificationId;
  VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {


  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify",style: TextStyle(color: Colors.white),),
        centerTitle: true,
          backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    hintText: 'Please Enter Valid Code',
                    border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                ),
              ),
              SizedBox(height: 50,),

              ElevatedButton(

                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.blue,
                    textStyle: TextStyle(fontSize: 20)
                  ),
                  onPressed: ()async{
                final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId, smsCode: phoneNumberController.text.toString());
                   try{
                     await auth.signInWithCredential(credential);


                   Navigator.pushNamed(context, 'welcome_screen');

                   }catch(e){
                     print(e.toString());


                   }

              }, child: Text("Verify",style: TextStyle(color: Colors.white),)

              ),



            ],


          ),
        ),
      ),
    );
  }
}
