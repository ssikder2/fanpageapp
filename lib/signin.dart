import 'package:fanpage/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignIn();
}

class _SignIn extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _loading
            ? LoadingPage()
            : Center(
                child: Form(
                    child: Column(
                children: [
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
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loading = true;
                        logIn(context);
                      });
                    },
                    child: const Text("Log in"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Register"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterPage()));
                    },
                    child: const Text("Sign in with Socials"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password"),
                  ),
                ],
              ))));
  }

  void logIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
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
    }
  }
}

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
