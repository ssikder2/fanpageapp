import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference posts = FirebaseFirestore.instance.collection("posts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          DatabaseService.userMap[_auth.currentUser!.uid]!.role == "ADMIN"
              ? FloatingActionButton(
                  onPressed: () {
                    addPost();
                  },
                  child: const Text("ADMIN POST"),
                )
              : null,
      body: StreamBuilder<QuerySnapshot>(
        stream: posts.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong querying users");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot doc) {
            var post = doc.data() as Map<String, dynamic>;
            return ListTile(title: Text(post["message"]));
          }).toList());
        },
      ),
    );
  }

  void addPost() async {
    await _db.collection("posts").add({"message": "RANDOM STUFF CAN GO HERE"});
  }
}
