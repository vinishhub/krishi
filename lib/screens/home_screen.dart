import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:krishi/screens/product_list.dart';
import 'package:krishi/widgets/banner_widget.dart';
import 'package:krishi/widgets/category_widget.dart';
import 'package:krishi/widgets/custom_appbar.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';
  final LocationData? locationData;

  HomeScreen({this.locationData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = 'India';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey.shade100,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: SafeArea(child: CustomAppBar())),
      body: SingleChildScrollView(
  physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0,12 , 8),
                child: Column(
                  children: [
                    BannerWidget(),
                    CategoryWidget(),

                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),

            //product list
            ProductList(),





          ],
        ),
      ),
    );
  }
}
