import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'location_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        Duration(
          seconds:3,
        ),()
    {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context,LoginScreen.id);
        } else {
          Navigator.pushReplacementNamed(context,LocationScreen.id);
        }
      });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    const colorizeColors = [
      Colors.blue,
      Colors.grey,

    ];
    const colorizeTextStyle = TextStyle(
      fontSize: 40.0,
      fontFamily: 'DancingScript',
    );




    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [Image.asset('assets/images/Farmer.png',width: 250, height: 250
          ),
            SizedBox(height:10,),
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'Krishi Agri',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),

              ],
              isRepeatingAnimation: true,
              onTap: () {
                print("Tap Event");
              },
            ),

          ],
        ),
      ),
    );
  }
}