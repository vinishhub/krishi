import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:krishi/screens/categories/subCat_screen.dart';
import 'package:krishi/services/firebase_service.dart';


class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({Key? key}) : super(key: key);
  static const String id = 'Category-list-screen';

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.grey),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Categories',style: TextStyle(color: Colors.black,),),

      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories.get(),
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
                        if(doc['subCat']==null){
                          return print('No sub Categories');
                        }
                        Navigator.pushNamed(context, SubCatList.id,arguments: doc, );
                      },
                     leading: Image.network(doc['image'],width: 40,),
                      title: Text(doc['catName'],style: TextStyle(fontSize: 15),),
                      trailing: Icon(Icons.arrow_forward_ios,size: 12,),
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
