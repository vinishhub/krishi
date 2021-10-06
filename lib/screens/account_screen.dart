import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Text('Account Screen',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
      ),
    );
  }
}
