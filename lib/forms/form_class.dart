import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishi/provider/cat_provider.dart';

class FormClass {
  List Bbrand = [
    'Tiger',
    'Utkarsh',
    ' Rajshree',
    'Rom',
    'Azogro',
    'PHOSOL',
    'Other'
  ];

  List cbrand=[
    'Katyayani',
    'Farmtone',
    'Greatindos',

  ];
  List bpesticides=[
    'Miraj',
    'Alpha',
    'ThriPan',
    'Amruth',
    'Ceaxor'
  ];
  List insecti=[
    'Powder',
    'Liquid'
  ];


  Widget appBar(CategoryProvider _provider) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      shape: Border(
        bottom: BorderSide(color: Colors.grey.shade300),
      ),
      title: Text(
        _provider.SelectedSubCat.toString(),
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
