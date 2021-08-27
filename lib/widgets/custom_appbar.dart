import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishi/screens/location_screen.dart';
import 'package:krishi/services/firebase_service.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    return FutureBuilder<DocumentSnapshot>(
      future: _service.users.doc(_service.user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Address not selected");
        }

        if (snapshot.connectionState==ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<
              String,
              dynamic>;
          if (data['address'] == null) {
            GeoPoint latLong = data['location'];
            _service.getAddress(latLong.latitude, latLong.longitude).then((
                adress) {
              return appBar(adress, context);
            });
          } else {
            return appBar(data['address'], context);
          }
        }
        return appBar('Fetch Location', context);
      },
    );
  }

  Widget appBar(address, context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>LocationScreen(locationChanging: true,),),);
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.location_solid,
                  color: Colors.black,
                  size: 18,
                ),
                Flexible(
                  child: Text(
                    address,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.black,
                  size: 12,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
