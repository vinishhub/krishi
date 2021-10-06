//tools form

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:krishi/provider/cat_provider.dart';
import 'package:krishi/forms/user_review_screen.dart';
import 'package:krishi/services/firebase_service.dart';
import 'package:krishi/widgets/imagePicker_widget.dart';
import 'package:provider/provider.dart';

class SellertoolsForm extends StatefulWidget {
  static const String id = 'tools-form';

  @override
  _SellertoolsFormState createState() => _SellertoolsFormState();
}

class _SellertoolsFormState extends State<SellertoolsForm> {
  final _formKey = GlobalKey<FormState>();

  FirebaseService _service = FirebaseService();
  var _etypecontroller = TextEditingController();
  var _namecontroller = TextEditingController();
  var _pricecontroller = TextEditingController();
  var _typecontroller = TextEditingController();
  var _desccontroller = TextEditingController();
  var _addcontroller = TextEditingController();

  validate(CategoryProvider provider) {
    if (_formKey.currentState!.validate()) {
      if (provider.urlList.isNotEmpty) {
        provider.dataToFirestore.addAll({
          'category': provider.SelectedCategory,
          'subCat':provider.SelectedSubCat,
          'brand': _etypecontroller.text,
          'name': _namecontroller.text,
          'price': _pricecontroller.text,
          'type': _typecontroller.text,
          'description': _desccontroller.text,
          'address': _addcontroller.text,
          'sellerUid': _service.user!.uid,
          'images': provider.urlList,
          'postedAt':DateTime.now().microsecondsSinceEpoch
        });
        print(provider.dataToFirestore);
        Navigator.pushNamed(context, UserReviewScreen.id);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image not Uploaded'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete required fields'),
        ),
      );
    }
  }

  List<String> _TypeList = ['Automatic', 'Manual'];
  @override
  void didChangeDependencies() {
    var _catProvider = Provider.of<CategoryProvider>(context);
    setState(() {
      _etypecontroller.text=_catProvider.dataToFirestore.isEmpty?null:_catProvider.dataToFirestore['brand'];
      _namecontroller.text=_catProvider.dataToFirestore.isEmpty?null:_catProvider.dataToFirestore['name'];
      _pricecontroller.text=_catProvider.dataToFirestore.isEmpty?null:_catProvider.dataToFirestore['price'];
      _typecontroller.text=_catProvider.dataToFirestore.isEmpty?null:_catProvider.dataToFirestore['type'];
      _desccontroller.text=_catProvider.dataToFirestore.isEmpty?null:_catProvider.dataToFirestore['description'];
      _addcontroller.text=_catProvider.dataToFirestore.isEmpty?null:_catProvider.dataToFirestore['address'];
      _etypecontroller.text=_catProvider.dataToFirestore.isEmpty?null:_catProvider.dataToFirestore['brand'];

    });
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);
    Widget _appBar(title, fieldValue) {
      return AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
        title: Text(
          '$title > $fieldValue',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    }

    Widget _brandList() {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.SelectedCategory, 'brand'),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _catProvider.doc!['Equipment'].length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          _etypecontroller.text =
                              _catProvider.doc!['Equipment'][index];
                        });
                      }
                      Navigator.pop(context);
                    },
                    title: Text(_catProvider.doc!['Equipment'][index]),
                  );
                }),
          ],
        ),
      );
    }

    Widget _listView({fieldValue, list, textController}) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.SelectedCategory, fieldValue),
            ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      textController.text = list[index];
                      Navigator.pop(context);
                    },
                    title: Text(list[index]),
                  );
                })
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'Add some details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tools',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _brandList();
                          });
                    },
                    child: TextFormField(
                      autofocus: true,
                      controller: _etypecontroller,
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Equipment Type'),

                    ),
                  ),
                  TextFormField(
                    controller: _namecontroller,
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    decoration: InputDecoration(labelText: 'Model Name*'),

                  ),
                  TextFormField(
                    autofocus: false,
                    controller: _pricecontroller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price*',
                      prefixText: '₹',
                    ),

                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'Type',
                                list: _TypeList,
                                textController: _typecontroller);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _typecontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Type',
                      ),
                    ),
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: _desccontroller,
                    keyboardType: TextInputType.text,
                    maxLength: 5000,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      helperText:
                          'Mention some features(eg. ModelName ,ModelYear)',
                    ),

                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Divider(
                    color: Colors.grey,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4)),
                    child: _catProvider.urlList.length == 0
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'No image selected',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : GalleryImage(
                            imageUrls: _catProvider.urlList,
                          ),
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ImagePickerWidget();
                            });
                      });
                    },
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        border: NeumorphicBorder(
                          color: Theme.of(context).primaryColor
                        )
                      ),
                      child: Container(
                        height: 40,
                        child: Center(
                          child: Text(_catProvider.urlList.length > 0
                              ? 'Upload more image'
                              : 'Upload more image'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeumorphicButton(
                style: NeumorphicStyle(color: Theme.of(context).primaryColor),
                child: Text(
                  'Save',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  validate(_catProvider);
                  print(_catProvider.dataToFirestore);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
