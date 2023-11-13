import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:login_firebase/rounded_btn.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'design_widget.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  String? fullName;
  final _fireStore = FirebaseFirestore.instance;
  String? phoneNumber;
  double pass_strength = 0;

  bool showSpinner = false;
  ImagePicker picker = ImagePicker();
  File? _image;

  String? image;
  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  Future<String?> uploadImage(var imageFile) async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload =
        referenceDirImages.child('$uniqueFileName.jpg');
    UploadTask uploadTask = referenceImageToUpload.putFile(imageFile);
    try {
      await uploadTask.whenComplete(() async {
        image = await referenceImageToUpload.getDownloadURL();
        print(image);
      });
      return image.toString();
    } catch (onError) {
      print("Error: $onError");
      return null;
    }
  }

  Future pickImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("'no Image picked");
      }
    });
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _registerUser() async {
    setState(() {
      showSpinner = true;
    });
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            "Register Screen",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Stack(alignment: Alignment.center, children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipOval(
                        child: _image != null
                            ? Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                "https://www.alleycat.org/wp-content/uploads/2019/03/FELV-cat.jpg",
                                fit: BoxFit.cover),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(left: 90, top: 50),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(80)),
                        child: IconButton(
                          color: Color(0xFF404040),
                          onPressed: () {
                            pickImageGallery();
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      fullName = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Full Name',
                    ),
                    validator: (value) {
                      fullName = value;
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Some Your Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter Your Email'),
                    validator: (value) {
                      email = value;

                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!emailRegex.hasMatch(value)) {
                        return 'Invalid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: !_passwordVisible,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                      _formKey.currentState!.validate();
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      password = value;
                      if (value == null || value.isEmpty) {
                        setState(() {
                          pass_strength = 0;
                        });
                        return 'Password is required';
                      } else {
                        if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                          setState(() {
                            pass_strength = 1 / 4;
                          });
                          return 'Password must contain at least one uppercase letter, one lowercase letter, and one digit';
                        } else {
                          setState(() {
                            pass_strength = 4 / 4;
                          });
                        }
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        phoneNumber = value;
                      });
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: "Enter your Phone Number"),
                    validator: (value) {
                      phoneNumber = value;

                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      } else if (value.length != 11) {
                        return 'Phone number must be 11 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.0),

                  LinearProgressIndicator(
                    value: pass_strength,
                    backgroundColor: Colors.grey[300],
                    minHeight: 5,
                    color: pass_strength <= 1 / 4
                        ? Colors.red
                        : pass_strength == 2 / 4
                        ? Colors.yellow
                        : pass_strength == 3 / 4
                        ? Colors.blue
                        : Colors.green,
                  ),
                  RoundedButton(
                    colour: Colors.green,
                    title: 'Register',
                    onPressed2: () async {
                      if (_formKey.currentState!.validate() && pass_strength == 1) {
                        _registerUser();

                        final uploadedImageUrl = await uploadImage(_image);

                        if (email != null &&
                            password != null &&
                            phoneNumber != null &&
                            uploadedImageUrl != null) {
                          try {
                            final newUser =
                                await _auth.createUserWithEmailAndPassword(
                              email: email!,
                              password: password!,
                            );

                            if (newUser != null) {
                              await _fireStore
                                  .collection('users')
                                  .doc(newUser.user!.uid)
                                  .set({
                                'fullName': fullName,
                                'phoneNumber': phoneNumber,
                                'imageUrl': uploadedImageUrl,
                                'email': email, // Include the email here
                              });

                              Navigator.pushNamed(context, 'home_screen');
                            }
                          } catch (e) {
                            if (e is FirebaseAuthException &&
                                e.code == 'email-already-in-use') {
                              _showSnackbar(
                                  'Email is already registered. Please log in.');
                            } else {
                              print(e);
                            }
                          }
                        }

                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
