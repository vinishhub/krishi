import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:krishi/provider/product_provider.dart';
import 'package:like_button/like_button.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String id = 'product-details-screen';

  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late GoogleMapController _controller;

  bool _loading = true;
  int _index = 0;

  final _format = NumberFormat('##,##,##0');

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  _mapLauncher(location) async {
    final availableMaps = await launcher.MapLauncher.installedMaps;
    print(
        availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

    await availableMaps.first.showMarker(
      coords: launcher.Coords(location.latitude, location.longitude),
      title: "Seller Location is here",
    );
  }

  _callSeller(number) {
    launch(number);
  }

  @override
  Widget build(BuildContext context) {
    var _productProvider = Provider.of<ProductProvider>(context);
    var data = _productProvider.productData;
    var _price = int.parse(data!['price']);
    String price = _format.format(_price);

    GeoPoint _location = _productProvider.sellerDetails!['location'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          LikeButton(
            circleColor: const CircleColor(
                start: Color(0xff00ddff), end: Color(0xff0099cc)),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Color(0xff33b5e5),
              dotSecondaryColor: Color(0xff0099cc),
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                color: isLiked ? Colors.redAccent : Colors.grey,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  color: Colors.grey.shade300,
                  child: _loading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Loading Please Wait 😉'),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            Center(
                              child: PhotoView(
                                backgroundDecoration:
                                    BoxDecoration(color: Colors.grey.shade300),
                                imageProvider:
                                    NetworkImage(data['images'][_index]),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data['images'].length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _index = i;
                                        });
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        child: Image.network(data['images'][i]),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _loading
                    ? Container()
                    : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(data['name'].toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              '\₹${price}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blueAccent),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.grey.shade300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data['description']),
                                          const SizedBox(height: 10),
                                          if (data['subCat'] == null ||
                                              data['subCat'] ==
                                                  ' Biological Fertilizers' ||
                                              data['subCat'] ==
                                                  ' Organic Fertilizers' ||
                                              data['subCat'] ==
                                                  ' Chemical Fertilizers')
                                            Text('Brand:${data['brand']}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
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
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ListTile(
                                      title: Text(
                                        _productProvider
                                                    .sellerDetails!['name'] ==
                                                null
                                            ? ''
                                            : _productProvider
                                                .sellerDetails!['name']
                                                .toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                      subtitle: const Text(
                                        'SEE PROFILE',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 12,
                                        ),
                                        onPressed: () {},
                                      )),
                                )
                              ],
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            const Text(
                              'Product Posted At',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 200,
                              color: Colors.grey.shade300,
                              child: Stack(
                                children: [
                                  Center(
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(_location.latitude,
                                            _location.longitude),
                                        zoom: 15,
                                      ),
                                      mapType: MapType.normal,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        setState(() {
                                          _controller = controller;
                                        });
                                      },
                                    ),
                                  ),
                                  const Center(
                                      child: Icon(
                                    Icons.location_on,
                                    size: 35,
                                  )),
                                  const Center(
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.black12,
                                    ),
                                  ),
                                  Positioned(
                                    right: 4.0,
                                    top: 4.0,
                                    child: Material(
                                      elevation: 4,
                                      shape: Border.all(
                                          color: Colors.grey.shade300),
                                      child: IconButton(
                                          icon: const Icon(
                                              Icons.alt_route_outlined),
                                          onPressed: () {
                                            _mapLauncher(_location);
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'AD ID:${data['postedAt']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('REPORT THIS AD',
                                      style: TextStyle(color: Colors.blue)),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                  child: NeumorphicButton(
                onPressed: () {},
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        CupertinoIcons.chat_bubble,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Chat',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              )),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: NeumorphicButton(
                  onPressed: () {
                    _callSeller(
                        'tel:${_productProvider.sellerDetails!['mobile']}');
                  },
                  style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          CupertinoIcons.phone,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Chat',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
