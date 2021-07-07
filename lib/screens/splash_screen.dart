import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    const colorizeColors = [
      Colors.blue,
      Colors.black,

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
