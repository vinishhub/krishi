import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoder/geocoder.dart';
import 'package:krishi/services/firebase_service.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart';

import 'home_screen.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location-screen';
  final bool? locationChanging;

  LocationScreen({this.locationChanging});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  FirebaseService _service = FirebaseService();
  Location location = new Location();
  bool _loading = true;

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  String _address = "";
  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String? manualAddress;

  Future<LocationData?> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    final coordinates =
        Coordinates(_locationData.latitude, _locationData.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      _address = first.addressLine;
      countryValue = first.countryName;
    });

    return _locationData;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.locationChanging == null) {
      _service.users
          .doc(_service.user!.uid)
          .get()
          .then((DocumentSnapshot document) {
        if (document.exists) {
          if (document['address'] != null) {
            setState(() {
              _loading = true;
            });
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          } else {
            setState(() {
              _loading = false;
            });
          }
        }
      });
    } else {
      setState(() {
        _loading=false;
      });
    }

    //Create an instance of ProgressDialog
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: 'Fetching location...',
      progressIndicatorColor: Theme.of(context).primaryColor,
    );

    showBottomScreen(context) {
      getLocation().then((location) {
        if (location != null) {
          progressDialog.dismiss();
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (context) {
                return Column(
                  children: [
                    SizedBox(
                      height: 26,
                    ),
                    AppBar(
                      automaticallyImplyLeading: false,
                      iconTheme: IconThemeData(
                        color: Colors.black,
                      ),
                      elevation: 1,
                      backgroundColor: Colors.white,
                      title: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.clear),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Location',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: SizedBox(
                          height: 40,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Search City,area or neighbourhood',
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        progressDialog.show();
                        getLocation().then((value) {
                          if (value != null) {
                            _service.updateUser({
                              // 'location':GeoPoint(value.latitude,value.longitude),
                              'address': _address
                            }, context).then((value) {
                              Navigator.pushNamed(context, HomeScreen.id);
                            });
                          }
                        });
                      },
                      horizontalTitleGap: 0.0,
                      leading: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                      ),
                      title: Text(
                        'Use current location',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        location == null ? 'Fetching location' : _address,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.shade300,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 0, bottom: 4, top: 4),
                          child: Text(
                            'CHOOSE City',
                            style: TextStyle(
                                color: Colors.blueGrey.shade900, fontSize: 12),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: CSCPicker(
                        layout: Layout.vertical,
                        flagState: CountryFlag.DISABLE,
                        dropdownDecoration:
                            const BoxDecoration(shape: BoxShape.rectangle),
                        defaultCountry: DefaultCountry.India,
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                            manualAddress =
                                '$cityValue,$stateValue,$countryValue';
                          });
                          if (value != null) {
                            _service.updateUser({
                              'address': manualAddress,
                              'state': stateValue,
                              'city': cityValue,
                              'country': countryValue
                            }, context);
                          }
                        },
                      ),
                    ),
                  ],
                );
              });
        } else {
          progressDialog.dismiss();
        }
      });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
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
            _loading
                ? Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Finding location...')
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10, top: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: _loading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor),
                                    ))
                                  : ElevatedButton.icon(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context).primaryColor),
                                      ),
                                      icon: Icon(CupertinoIcons.location_fill),
                                      label: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, bottom: 15),
                                        child: Text(
                                          "Detect Location",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      onPressed: () {
                                        progressDialog.show();

                                        getLocation().then((value) {
                                          if (value != null) {
                                            _service.updateUser({
                                              'address': _address,
                                              //'location':GeoPoint(value.latitude,value.longitude);
                                            }, context).whenComplete(() {
                                              progressDialog.dismiss();
                                            });
                                          }
                                        });
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          progressDialog.show();
                          showBottomScreen(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(width: 2)),
                            ),
                            child: const Text(
                              "Set Location manually",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ));
  }
}
