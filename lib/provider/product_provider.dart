import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider  with ChangeNotifier{
   DocumentSnapshot? productData;
   DocumentSnapshot? sellerDetails;


  getProductDetails(details){
    productData=details;
    notifyListeners();
  }

  getSellerDetails(details){
    sellerDetails=details;
    notifyListeners();

  }
}
