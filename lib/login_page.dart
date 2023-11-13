import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_firebase/rounded_btn.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'design_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  bool _passwordVisible = false;
  InputDecoration? emailDecoration;
  InputDecoration emailDecoration2 =
      kTextFieldDecoration.copyWith(hintText: "Enter Your Email");
  InputDecoration? passwordDecoration;

  bool showSpinner = false;
  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, and one digit';
    }
    return null;
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Login Screen",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: emailDecoration ?? emailDecoration2,
              ),
              SizedBox(
                height: 30.0,
              ),
              TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: !_passwordVisible,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  decoration: passwordDecoration ??
                      kTextFieldDecoration.copyWith(
                        hintText: "Enter Your password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      )),
              SizedBox(
                height: 3.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {

                    Navigator.pushNamed(context, 'forgot_password');

                  }, child: Text("Forgot Password"))
                ],
              ),
              RoundedButton(
                colour: Colors.green,
                title: 'Log In',
                onPressed2: () async {
                  setState(() {
                    showSpinner = true;
                  });

                  if (email == null) {
                    emailDecoration = kTextFieldDecoration.copyWith(
                      errorText: validateEmail(email),
                      hintText: 'Enter your email',
                    );
                  }
                  if (password == null) {
                    passwordDecoration = kTextFieldDecoration.copyWith(
                      errorText: validatePassword(password),
                      hintText: 'Enter your Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    );
                  } else {
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                        email: email!,
                        password: password!,
                      );
                      if (user != null) {
                        Navigator.pushNamed(context, 'home_screen');
                      }
                    } catch (e) {
                      print(e);
                    }
                  }

                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
