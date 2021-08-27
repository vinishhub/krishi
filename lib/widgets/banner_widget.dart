import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .30,
          color: Colors.blueAccent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Farming related Products',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                              letterSpacing: 1,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 45.0,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                              child: AnimatedTextKit(
                                repeatForever: true,
                                isRepeatingAnimation: true,
                                animatedTexts: [
                                  FadeAnimatedText(
                                    'Buy Farming\nrelated product',
                                    duration: Duration(seconds: 4),
                                  ),
                                  FadeAnimatedText(
                                    'New way to Buy and Sell\nFarming Utilities ',
                                    duration: Duration(seconds: 4),
                                  ),
                                  FadeAnimatedText(
                                    'Trusted Sellers and \nQuality Products',
                                    duration: Duration(seconds: 4),
                                  ),
                                  FadeAnimatedText(
                                    'ISO Certified Pesticides \nand Fertilizers',
                                    duration: Duration(seconds: 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Neumorphic(
                        style: NeumorphicStyle(
                          color: Colors.white,
                          oppositeShadowLightSource: true,
                        ),
                        child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/krishi-8b8e4.appspot.com/o/banner%2Ficons8-fertilizer-100.png?alt=media&token=e1c397c4-dab4-4447-bfa4-2903371c7025'),
                      )
                    ],
                  ),
                ),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () {},
                      style: NeumorphicStyle(color: Colors.white),
                      child: Text(
                        'Buy Farm Products',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () {},
                      style: NeumorphicStyle(color: Colors.white),
                      child: Text(
                        'Sell Farm products',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          )),
    );
  }
}
