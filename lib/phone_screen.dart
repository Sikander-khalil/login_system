import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_firebase/verify_code.dart';

class PhoneField extends StatefulWidget {
  const PhoneField({Key? key}) : super(key: key);

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column( 
            children: [
              SizedBox(
                height: 80,
              ),
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: '+1 234 3455 234',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
                
                ),
              ),
              SizedBox(
                height: 80,
              ),
              ElevatedButton(
                  child: Text('Login',style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    setState(() {
                      loading = true;
                    });

                    auth.verifyPhoneNumber(
                        phoneNumber: phoneNumberController.text,
                        verificationCompleted: (_) {
                          setState(() {
                            loading = false;
                          });
                        },
                        verificationFailed: (e) {
                          setState(() {
                            loading = false;
                          });
                          print(e.toString());
                        },
                        codeSent: (String verificationId, int? token) {
                        Get.to(() => VerifyCodeScreen(verificationId: verificationId));
                          setState(() {
                            loading = false;
                          });
                        },
                        codeAutoRetrievalTimeout: (e) {
                          print(e.toString());
                          setState(() {
                            loading = false;
                          });
                        });

                  },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: TextStyle(fontSize: 20)
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
