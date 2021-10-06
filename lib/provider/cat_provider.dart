import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:krishi/services/firebase_service.dart';

class CategoryProvider with ChangeNotifier {
  FirebaseService _service = FirebaseService();

  DocumentSnapshot? doc;
  DocumentSnapshot? userDetails;
  String? SelectedCategory;
  String? SelectedSubCat;

  List<String> urlList = [];
  Map<String, dynamic> dataToFirestore = {};


  getCategory(selectedCat) {
    this.SelectedCategory = selectedCat;
    notifyListeners();
  }

  getSubCategory(selectedsubCat) {
    this.SelectedSubCat = selectedsubCat;
    notifyListeners();
  }
  getCatSnapshot(snapshot) {
    this.doc = snapshot;
    notifyListeners();
  }

  getImages(url) {
    this.urlList.add(url);
    notifyListeners();
  }

  getData(data) {
    this.dataToFirestore = data;
    notifyListeners();
  }

  getUserDetails() {
    _service.getUserData().then((value) {
      this.userDetails = value;

      notifyListeners();
    });
  }
  clearData(){
    this.urlList = [];
    dataToFirestore = {};
    notifyListeners();

  }
}
