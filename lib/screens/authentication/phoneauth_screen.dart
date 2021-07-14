
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:krishi/services/phoneauth_service.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const String id = 'phone-auth-screen';

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  bool validate = false;
  var countryCodeController = TextEditingController(text: '+91');
  var phoneNumberController = TextEditingController();



  PhoneAuthService _service =PhoneAuthService();





  @override
  Widget build(BuildContext context) {
    //Create an instance of ProgressDialog
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Please wait',
      progressIndicatorColor: Theme.of(context).primaryColor,

    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Login',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade200,
              child: Icon(
                CupertinoIcons.person_alt_circle,
                color: Colors.blue,
                size: 60,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Enter your Phone',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'We will send confirmation code to your Phone Number',
              style: TextStyle(color: Colors.grey),
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: TextFormField(
                      autofocus: true,
                      controller: countryCodeController,
                      enabled: false,
                      decoration: InputDecoration(
                          counterText: '00', labelText: 'Country'),
                    )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 3,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == 10) {
                          setState(() {
                            validate = true;
                          });
                        } if(value.length<10){
                          validate=false;
                        }
                      },
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Number',
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AbsorbPointer(
            absorbing: validate  ? false : true,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: validate
                        ? MaterialStateProperty.all(
                            Theme.of(context).primaryColor)
                        : MaterialStateProperty.all(Colors.grey)),
                onPressed: () {
                  progressDialog.show();
                  String number =
                      '${countryCodeController.text}${phoneNumberController.text}';
                    _service.verifyPhoneNumber(context, number);
                  //progressDialog.dismiss();

                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
