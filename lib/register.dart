import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanpage/database_service.dart';
import 'package:fanpage/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _Register();
}

class _Register extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _display = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Registration")),
        body: _loading
            ? LoadingPage()
            : Center(
                child: Form(
                    child: Column(
                children: [
                  TextFormField(
                      controller: _display,
                      validator: (String? text) {
                        if (text == null || text.isEmpty) {
                          return "Your you must have a display name.";
                        } else if (DatabaseService.usernames
                            .contains(text.toLowerCase())) {
                          return "Dsiplay name already in use";
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: _email,
                      validator: (String? text) {
                        if (text == null || text.isEmpty) {
                          return "Your forgot to enter an email address.";
                        } else if (!text.contains('@')) {
                          return "Your email is formatted incorrectly.";
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: _password,
                      validator: (String? text) {
                        if (text == null || text.length < 6) {
                          return "Your password must have atleast 6 chharacters";
                        }
                        return null;
                      }),
                  TextFormField(validator: (String? text) {
                    if (text == null || text.length < 6) {
                      return "Your password must have atleast 6 chharacters";
                    } else if (text != _password.text) {
                      return "Your passwords do not match.";
                    }
                    return null;
                  }),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loading = true;
                        register(context);
                      });
                    },
                    child: const Text("Register"),
                  ),
                ],
              ))));
  }

  void register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: _email.text, password: _password.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == "wrong-password" || e.code == "no-email") {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Incorrect email/password")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      try {
        if (_auth.currentUser != null) {
          await _db.collection("users").doc(_auth.currentUser!.uid).set({
            "display_name": _display.text,
            "role": "USER",
            "email": _email.text
          });
        }
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "Unknown Error")));
      }
    }
  }
}
