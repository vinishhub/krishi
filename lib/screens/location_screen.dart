import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:krishi/screens/login_screen.dart';

class LocationScreen extends StatelessWidget {
  static const String id = 'location-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Image.asset('assets/images/Location.png'),
        SizedBox(
          height: 20,
        ),
        Text(
          'Enter Your Delivery Location',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.location_fill),
                  label: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                      "Confirm Location",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Set location manually',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    ));
  }
}
