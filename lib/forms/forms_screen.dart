import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:krishi/forms/form_class.dart';
import 'package:krishi/forms/user_review_screen.dart';
import 'package:krishi/provider/cat_provider.dart';
import 'package:krishi/services/firebase_service.dart';
import 'package:krishi/widgets/imagePicker_widget.dart';
import 'package:provider/provider.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({Key? key}) : super(key: key);
  static const String id = 'form-screen';

  @override
  _FormsScreenState createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  FormClass _formClass = FormClass();
  final _formKey = GlobalKey<FormState>();
  FirebaseService _service = FirebaseService();
  var _brandText = TextEditingController();
  var _nameController = TextEditingController();
  var _descController = TextEditingController();
  var _priceController = TextEditingController();
  var _biobrandText = TextEditingController();
  var _insectText=TextEditingController();
  var _cbrandText = TextEditingController();
  var _bpestiText = TextEditingController();

  validate(CategoryProvider provider) {
    if (_formKey.currentState!.validate()) {
      if (provider.urlList.isNotEmpty) {
        provider.dataToFirestore.addAll({
          'category': provider.SelectedCategory,
          'subCat': provider.SelectedSubCat,
          'brand': _brandText.text,
          '_insectText':_insectText.text,
          '_biobrandText': _biobrandText.text,
          'name': _nameController.text,
          'price': _priceController.text,
          '_bpestiText':_bpestiText.text,
          'description': _descController.text,
          'sellerUid': _service.user!.uid,
          'images': provider.urlList,
          'postedAt': DateTime.now().microsecondsSinceEpoch
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

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);
    showFormDialog(list, _textController) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _formClass.appBar(_provider),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int i) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              _textController.text = list[i];
                            });
                            Navigator.pop(context);
                          },
                            title: Text(list[i]),

                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          });
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
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${_provider.SelectedCategory}>${_provider.SelectedSubCat}'),
                if (_provider.SelectedSubCat == 'Biological Fertilizers')
                  InkWell(
                    onTap: () {
                      showFormDialog(_formClass.Bbrand,_biobrandText);
                    },
                    child: TextFormField(
                      controller: _biobrandText,
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Brand'),
                    ),
                  ),
                if (_provider.SelectedSubCat == 'Chemical Fertilizers')
                  InkWell(
                    onTap: () {
                      showFormDialog(_formClass.cbrand,_cbrandText);
                    },
                    child: TextFormField(
                      controller: _cbrandText,
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Brand'),
                    ),
                  ),
                if (_provider.SelectedSubCat == 'Organic Fertilizers')
                  InkWell(
                    onTap: () {
                      showFormDialog(_provider.doc!['brands'], _brandText);
                    },
                    child: TextFormField(
                      controller: _brandText,
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Brands'),
                    ),
                  ),
                //Insecticides

                if (_provider.SelectedSubCat == 'Bio Pesticides')
                  InkWell(
                    onTap: () {
                      showFormDialog(_formClass.bpesticides, _bpestiText);
                    },
                    child: TextFormField(
                      controller: _bpestiText,
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Brands'),
                    ),
                  ),
                if (_provider.SelectedSubCat == 'Insecticides')
                  InkWell(
                    onTap: () {
                      showFormDialog(_formClass.insecti, _insectText);
                    },
                    child: TextFormField(
                      controller: _insectText,
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Brands'),
                    ),
                  ),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  decoration: InputDecoration(labelText: 'Add Title'),
                ),
                TextFormField(
                  autofocus: false,
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price*',
                    prefixText: '₹',
                  ),
                ),
                TextFormField(
                  autofocus: false,
                  controller: _descController,
                  keyboardType: TextInputType.text,
                  maxLength: 5000,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    helperText: 'Tell us more about products',
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
                  child: _provider.urlList.length == 0
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'No image selected',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : GalleryImage(
                          imageUrls: _provider.urlList,
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                            color: Theme.of(context).primaryColor)),
                    child: Container(
                      height: 40,
                      child: Center(
                        child: Text(_provider.urlList.length > 0
                            ? 'Upload more image'
                            : 'Upload more image'),
                      ),
                    ),
                  ),
                ),
              ],
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
                  'NEXT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  validate(_provider);
                  print(_provider.dataToFirestore);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
