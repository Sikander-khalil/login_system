import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_firebase/design_widget.dart';
import 'package:login_firebase/rounded_btn.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(color: Colors.white),

        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: kTextFieldDecoration.copyWith(hintText: "Email"),
            ),
            SizedBox(
              height: 40,
            ),
            RoundedButton(
                colour: Colors.black,
                title: 'Forgot',
                onPressed2: () {
                  auth
                      .sendPasswordResetEmail(
                          email: emailController.text.toString())
                      .then((value) {
                    Get.snackbar("Email",
                        "We have sent you email to recover password, please check email");
                  }).onError((error, stackTrace) {
                    Get.snackbar("Error", error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
