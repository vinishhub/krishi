import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:krishi/screens/authentication/email_auth_screen.dart';
import 'package:krishi/screens/authentication/email_verification_screen.dart';
import 'package:krishi/screens/authentication/reset_password_screen.dart';
import 'package:krishi/screens/categories/category_list.dart';
import 'package:krishi/screens/categories/subCat_screen.dart';
import 'package:krishi/screens/home_screen.dart';
import 'package:krishi/screens/location_screen.dart';
import 'package:krishi/screens/login_screen.dart';
import 'package:krishi/screens/authentication/phoneauth_screen.dart';
import 'package:krishi/screens/splash_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
           primaryColor: Colors.indigo,
           fontFamily: 'RobotoSlab-Regular'
       ),
      initialRoute: SplashScreen.id,
      routes:{

        LoginScreen.id: (context) => LoginScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
        LocationScreen.id: (context) => LocationScreen(),
        EmailAuthScreen.id: (context) => EmailAuthScreen(),
        EmailVerificationScreen.id:(context)=>EmailVerificationScreen(),
        PasswordResetScreen.id:(context)=>PasswordResetScreen(),
        CategoryListScreen.id:(context)=>CategoryListScreen(),
        SubCatList.id:(context)=>SubCatList(),


      },
    )

      /* FutureBuilder(
      // Replace the 3 second delay with your initialization code:
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: Colors.indigo,
                  fontFamily: 'RobotoSlab-Regular'
              ),
              home: SplashScreen());
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.indigo,
                fontFamily: 'RobotoSlab-Regular'
            ),

            home: LoginScreen(),

            routes: {

              LoginScreen.id: (context) => LoginScreen(),
              PhoneAuthScreen.id: (context) => PhoneAuthScreen(),
              LocationScreen.id: (context) => LocationScreen(),
            },
          );
        }
      },
    );*/ ;
  }
}


