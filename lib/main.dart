import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fanpage/button.dart';
import 'package:fanpage/database_service.dart';
import 'package:fanpage/home.dart';
import 'package:fanpage/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DatabaseService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fan Page App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        duration: 2500,
        splash:
            '[n]https://media-exp1.licdn.com/dms/image/C4D03AQGJrZ_YdoYltg/profile-displayphoto-shrink_400_400/0/1608107388689?e=1651104000&v=beta&t=mRoDYwau0wG9Z8bodwkJgLE956raAdkRdhtlcqVobIA',
        nextScreen: MyHomePage(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Button(
                  colour: Colors.lightBlueAccent,
                  title: 'Log In',
                  onPressed: () {
                    Navigator.pushNamed(context, 'signin');
                  },
                ),
                Button(
                    colour: Colors.blueAccent,
                    title: 'Register',
                    onPressed: () {
                      Navigator.pushNamed(context, 'registrater');
                    }),
              ]),
        ));
  }
}
