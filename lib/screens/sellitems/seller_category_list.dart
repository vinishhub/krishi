import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:krishi/forms/tools_form.dart';
import 'package:krishi/provider/cat_provider.dart';
import 'package:krishi/screens/sellitems/seller_subCat.dart';
import 'package:krishi/services/firebase_service.dart';
import 'package:provider/provider.dart';


class SellerCategory extends StatelessWidget {
  const SellerCategory({Key? key}) : super(key: key);
  static const String id = 'Seller-Category-list-screen';

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider=Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.grey),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Choose Categories',style: TextStyle(color: Colors.black,),),

      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories.orderBy('sortId',descending: false).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }

            return Container(
              child: ListView.builder(

                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var doc = snapshot.data!.docs[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: (){
                        _catProvider.getCategory(doc['catName']);
                        _catProvider.getCatSnapshot(doc);
                        if(doc['subCat']==null){
                           Navigator.pushNamed(context, SellertoolsForm.id);
                        }
                        else {
                          Navigator.pushNamed(
                              context, SellerSubCatList.id, arguments: doc);
                        }
                      },
                     leading: Image.network(doc['image'],width: 40,),
                      title: Text(doc['catName'],style: TextStyle(fontSize: 15),),
                      trailing:doc['subCat']==null?null: Icon(Icons.arrow_forward_ios,size: 12,),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
