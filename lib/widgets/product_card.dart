import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishi/provider/product_provider.dart';
import 'package:krishi/screens/product_details_screen.dart';
import 'package:krishi/services/firebase_service.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.data,
    required String formattedPrice,
  })
      : _formattedPrice = formattedPrice,
        super(key: key);
  final QueryDocumentSnapshot<Object?> data;
  final String _formattedPrice;


  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  FirebaseService _service = FirebaseService();
  String? address = '';

  late DocumentSnapshot sellerDetails;


  @override
  void initState() {
    // TODO: implement initState
    _service.getSellerData(widget.data['sellerUid']).then((value) {
      if (mounted) {
        setState(() {
          address = value['address'];
          sellerDetails=value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);


    return InkWell(
      onTap: () {
        _provider.getProductDetails(widget.data);
        _provider.getSellerDetails(sellerDetails);

        Navigator.pushNamed(context, ProductDetailsScreen.id);
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    child: Center(
                      child: Image.network(widget.data['images'][0]),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget._formattedPrice,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.data['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                ],
              ),
              Positioned(
                right: 0.0,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: LikeButton(
                    circleColor:
                    CircleColor(
                        start: Color(0xff00ddff), end: Color(0xff0099cc)),
                    bubblesColor: BubblesColor(
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
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            border: Border.all(
              color:
              Theme
                  .of(context)
                  .primaryColor
                  .withOpacity(.8),
            ),
            borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}