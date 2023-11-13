import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextFormField(
              onChanged: (value) => authController.name.value = value,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              onChanged: (value) => authController.job.value = value,
              decoration: InputDecoration(labelText: 'Job'),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => authController.register(),
              child: Text('Sign Up'),
            ),

          ],
        ),
      ),
    );
  }
}
