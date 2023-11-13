import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllData extends StatefulWidget {
  const AllData({super.key});

  @override
  State<AllData> createState() => _AllDataState();
}

class _AllDataState extends State<AllData> {
  final _fireStore = FirebaseFirestore.instance;

  late Future<List<Map<String, dynamic>>> allUserData;

  Future<List<Map<String, dynamic>>> getAllUserData() async {
    List<Map<String, dynamic>> userDataList = [];

    try {
      QuerySnapshot usersSnapshot = await _fireStore.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        userDataList.add(userDoc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print(e);
    }

    return userDataList;
  }


  @override
  void initState() {
    super.initState();
    allUserData = getAllUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          title: Text(
            "All Data Available",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),

        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: allUserData,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No user data available.');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var userData = snapshot.data![index];
                  return ListTile(
                    title: Text(userData['fullName']),
                    subtitle: Text(userData['phoneNumber']),
                    leading: Image.network(
                      userData['imageUrl'] ?? 'https://www.alleycat.org/wp-content/uploads/2019/03/FELV-cat.jpg',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                    trailing: Text(userData['email'] ?? ''),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

