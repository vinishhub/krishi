import 'package:flutter/material.dart';
import 'package:krishi/widgets/auth_ui.dart';

class LoginScreen extends StatelessWidget {
  static const String id ='login-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade400,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,//device width
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  Image.asset('assets/images/Farmer.png',width: 200, height: 200,
                  ),
                  SizedBox(height: 10,),
                  const Text('Krishi Agri',style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily:'DancingScript',
                    color: Colors.blueAccent,
                  ),)
                ],
              ),
            ),),
          Expanded(
            child: Container(
              child: AuthUi(),
            ),
          ),



        ],
      ),
    );
  }
}
