import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_firebase/password_strength.dart';
import 'package:login_firebase/phone_screen.dart';


import 'package:login_firebase/register_screen.dart';
import 'package:login_firebase/welcome_screen.dart';

import 'all_data.dart';
import 'auth_page.dart';
import 'controller.dart';

import 'forgot_password.dart';
import 'home_screen.dart';
import 'login_page.dart';


User? currentUser = FirebaseAuth.instance.currentUser;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),


      initialRoute: currentUser != null ? 'home_screen' : 'welcome_screen',
      routes: {
        'welcome_screen': (context) => WelcomeScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'login_screen': (context) => LoginScreen(),
        'home_screen': (context) => HomeScreen(),
        'all_data' : (context) => AllData(),
        'auth_page' : (context) => AuthPage(),
        'PhoneField' : (context) => PhoneField(),
        'forgot_password' : (context) => ForgotPassword(),
        'password_screen' : (context) => PasswordScreen(),



      },
    );
  }
}

