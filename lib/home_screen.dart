import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  User? loggedUser;
  String? fullName;
  String? imageUrl;
  String? phoneNo;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUserData(_auth.currentUser!.uid);
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedUser = user;



      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserData(String userId) async {
    try {

      DocumentSnapshot userSnapshot =
      await _fireStore.collection('users').doc(userId).get();


      if (userSnapshot.exists) {
        setState(() {
          fullName = userSnapshot['fullName'];

          imageUrl = userSnapshot['imageUrl'];
          phoneNo = userSnapshot['phoneNumber'];
        });
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile Page',style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.red,
          leading: null,
          actions: [
            IconButton(
              icon: Icon(Icons.close,color: Colors.white,),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Full Name ${fullName}",
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    if (imageUrl != null)
                      Image(image: NetworkImage(imageUrl!))
                    else
                      Container(),
                    SizedBox(height: 10),
                    Text(phoneNo.toString()),
                      SizedBox(height: 10),

                      ElevatedButton(onPressed: (){
                        Navigator.pushNamed(context, 'all_data');

                      }, child: Text("All Data List",style: TextStyle(color: Colors.white),),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                      ),
                      )

                  ],



          ),
        ),

    )
    );
  }
}


