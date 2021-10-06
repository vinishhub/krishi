import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:krishi/provider/cat_provider.dart';
import 'package:krishi/screens/location_screen.dart';
import 'package:krishi/services/firebase_service.dart';
import 'package:provider/provider.dart';

import '../screens/main_screen.dart';

class UserReviewScreen extends StatefulWidget {
  static const String id = 'user-review-screen';

  @override
  _UserReviewScreenState createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  FirebaseService _service = FirebaseService();

  var _nameController = TextEditingController();
  var _countryCodeController = TextEditingController(text: '+91');
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _addController = TextEditingController();

  Future<void> updateUser(provider, Map<String, dynamic> data, context) {
    return _service.users
        .doc(_service.user!.uid)
        .update(data).
        then(
      (value) {
        saveProductToDb(provider, context);
      },
    ).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to Update Location'),
        ),
      );
    });
  }

  Future<void> saveProductToDb(CategoryProvider provider, context) {
    return _service.products
        .add(provider.dataToFirestore)
        .then(
          (value) {
            provider.clearData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('We have received your Products and will be notified you once get approved'),
              ),
            );
            Navigator.pushReplacementNamed(
                context, MainScreen.id);

          },
        )
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to Update Location'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    showConfirmDialog() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirm',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('Are you sure, you want to save below product'),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading:
                          Image.network(_provider.dataToFirestore['images'][0]),
                      title: Text(
                        _provider.dataToFirestore['name'],
                        maxLines: 1,
                      ),
                      subtitle: Text(_provider.dataToFirestore['price']),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NeumorphicButton(
                          onPressed: () {
                            setState(() {
                              _loading = false;
                            });
                            Navigator.pop(context);
                          },
                          style: NeumorphicStyle(
                              border: NeumorphicBorder(
                                  color: Theme.of(context).primaryColor),
                              color: Colors.transparent),
                          child: Text('Cancel'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        NeumorphicButton(
                          style: NeumorphicStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            'confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            updateUser(
                                    _provider,
                                    {
                                      'contactDetails': {
                                        'contactMobile': _phoneController.text,
                                        'contactMail': _emailController.text,
                                        'address':_addController.text,
                                      },
                                      'name': _nameController.text,

                                    },
                                    context)
                                .then((value) {
                              setState(() {
                                _loading = false;
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_loading)
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      )
                  ],
                ),
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'Add some details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      body: Form(
        key: _formKey,
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.getUserData(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              );
            }
            _nameController.text = snapshot.data!['name'];
            _phoneController.text = snapshot.data!['mobile'];
            _emailController.text = snapshot.data!['email'];
            _addController.text = snapshot.data!['address'];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 40,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            radius: 38,
                            child: Icon(
                              CupertinoIcons.person_alt,
                              color: Colors.blue.shade300,
                              size: 60,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Your name',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter mobile name ';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Contact Details',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _countryCodeController,
                              enabled: false,
                              decoration: InputDecoration(
                                  labelText: 'Country', helperText: ''),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Mobile number',
                              helperText: 'Enter contact mobile number',
                            ),
                            maxLength: 10,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        helperText: 'Enter contact email',
                      ),
                      validator: (value) {
                        final bool isValid =
                            EmailValidator.validate(_emailController.text);
                        if (value == null || value.isEmpty) {
                          return 'Enter Email';
                        }
                        if (value.isEmpty && isValid == false) {
                          return 'Enter valid email';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            autofocus: false,
                            controller: _addController,
                            keyboardType: TextInputType.text,
                            maxLength: 5000,
                            maxLines: 30,
                            minLines: 1,
                            decoration: InputDecoration(
                              labelText: 'Address*',
                              helperText: 'Contact  Address',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LocationScreen(
                                          popScreen: UserReviewScreen.id,
                                        )));
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        /**/
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: NeumorphicButton(
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Text(
                  'Confirm',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showConfirmDialog();
                  }


                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
