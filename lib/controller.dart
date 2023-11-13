import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:login_firebase/userModel.dart';
import 'package:http/http.dart' as http;
class AuthController extends GetxController {

  var name = ''.obs;
  var job = ''.obs;
  RxBool isLoggedIn = false.obs;

  Future<void> signUp(UserModel user) async {
    final isSuccess = await register();
    isLoggedIn.value = isSuccess;
  }

  Future register() async {
    final response = await http.post(
      Uri.parse('https://reqres.in/api/users'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'name': name.value,
        'job': job.value,
      },
    );

    if (response.statusCode == 201) {
      print("Registration successful!");

      final  data = jsonDecode(response.body);
      print(data);
    } else {

      print("Registration failed. Status code: ${response.statusCode}");
      print(response.body);
    }
  }

}
