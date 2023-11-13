import 'package:flutter/material.dart';
import 'package:login_firebase/rounded_btn.dart';


class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text("Login / Register Screen",style: TextStyle(color: Colors.white),),
            centerTitle: true,
          ),

          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RoundedButton(
                    colour: Colors.lightBlueAccent,
                    title: 'Log In',
                    onPressed2: () {
                      Navigator.pushNamed(context, 'login_screen');
                    },
                  ),
                  RoundedButton(
                      colour: Colors.green,
                      title: 'Register',
                      onPressed2: () {
                        Navigator.pushNamed(context, 'registration_screen');
                      }),

                  RoundedButton(
                      colour: Colors.black,
                      title: 'Login with phone',
                      onPressed2: () {
                        Navigator.pushNamed(context, 'PhoneField');
                      }),


                ]),
          )),
    );
  }
}