import 'dart:io';
import 'package:square_in_app_payments_example/models/art.dart';
import 'package:square_in_app_payments_example/services/art_notifier.dart';
import 'package:square_in_app_payments_example/widgets/provider_widget.dart';
import 'artwork_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodForm extends StatefulWidget {
  final bool isUpdating;

  FoodForm({@required this.isUpdating});

  @override
  _FoodFormState createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //var uid = await getUID();


  List _subingredients = [];
  Food _currentFood;
  String _imageUrl;
  File _imageFile;
  TextEditingController subingredientController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context, listen: false);

    if (foodNotifier.currentFood != null) {
      _currentFood = foodNotifier.currentFood;
    } else {
      _currentFood = Food();
    }

    _subingredients.addAll(_currentFood.medium);
    _imageUrl = _currentFood.image;

    //_currentFood.uid = authData.uid;
    // _currentFood.uid = Prov.of(context).auth.getCurrentUID();

  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text("image placeholder");
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

//  _getProfileData() {
//    final uid = Prov.of(context).auth;
//
//  }

  _getLocalImage() async {
    File imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildArtistField() => TextFormField(
      decoration: InputDecoration(labelText: 'Artist'),
      //initialValue: _firebaseAuth.currentUser().toString(),
      initialValue: "Ashley Mooney",
      //  initialValue: "name here",
      //  initialValue: "${authData.displayName}",
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Artist is required';
        }
        if (value.length < 1 || value.length > 20) {
          return 'Name must be more than 1 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentFood.artist = value;
        //authData.uid = value;
      },
    );


  Widget _buildUidField() => FutureBuilder(
      future: Prov.of(context).auth.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return displayUserInformation(context, snapshot);
        } else {
          return CircularProgressIndicator();
        }
      },
    );

  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;
    //  authData.uid = _currentFood.uid;
    return
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "${authData.uid}",
          style: TextStyle(fontSize: 20),
        ),
      );
  }

//  Widget _buildArtistField() {
//    //   final authData = snapshot.data;
//
//    return FutureBuilder(
//      future: Prov.of(context).auth.getCurrentUser(),
//      builder: (context, snapshot) {
//        if (snapshot.connectionState == ConnectionState.done) {
//          return displayUserName(context, snapshot);
//        } else {
//          return CircularProgressIndicator();
//        }
//      },
//    );
//  }
//
//  Widget displayUserName(context, snapshot) {
//    final authData = snapshot.data;
//    //authData.displayName = _currentFood.name;
//    return
//      Padding(
//        padding: const EdgeInsets.all(8.0),
//        child:
//       Text(
//          "${authData.displayName}",
//          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, decoration: TextDecoration.underline),
//        ),
//     );
//  }

  Widget _buildTitleField() => TextFormField(
      decoration: InputDecoration(labelText: 'Title'),
      initialValue: _currentFood.title,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Title is required';
        }

        if (value.length < 1 || value.length > 20) {
          return 'Name must be more than 1 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentFood.title = value;
      },
    );

  Widget _buildSizeField() => TextFormField(
      decoration: InputDecoration(labelText: 'Size'),
      initialValue: _currentFood.size,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Size is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Size must be in inches. Example: (width" x height") ';
        }

        return null;
      },
      onSaved: (String value) {
        _currentFood.size = value;
      },
    );

//  Widget _buildCategoryField() {
//    return TextFormField(
//      decoration: InputDecoration(labelText: 'Category'),
//      initialValue: _currentFood.category,
//      keyboardType: TextInputType.text,
//      style: TextStyle(fontSize: 20),
//      validator: (String value) {
//        if (value.isEmpty) {
//          return 'Category is required';
//        }
//
//        if (value.length < 3 || value.length > 20) {
//          return 'Category must be more than 3 and less than 20';
//        }
//
//        return null;
//      },
//      onSaved: (String value) {
//        _currentFood.category = value;
//      },
//    );
//  }

  Widget _buildDescriptionField() => TextFormField(
      decoration: InputDecoration(labelText: 'Description'),
      initialValue: _currentFood.description,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Description is required';
        }

        if (value.length < 3 || value.length > 200) {
          return 'Description must be more than 3 and less than 200';
        }

        return null;
      },
      onSaved: (String value) {
        _currentFood.description = value;
      },
    );

  Widget _buildPriceField() => TextFormField(
      decoration: InputDecoration(labelText: 'Price'),
      initialValue: _currentFood.price,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Price is required';
        }

//        if (value.length < 3 || value.length > 200) {
//          return 'Description must be more than 3 and less than 200';
//        }

        return null;
      },
      onSaved: (String value) {
        _currentFood.price = value;
      },
    );

  _buildSubingredientField() => SizedBox(
      width: 200,
      child: TextField(
        controller: subingredientController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'Medium(s) Used'),
        style: TextStyle(fontSize: 20),
      ),
    );

  _onFoodUploaded(Food food) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context, listen: false);
    foodNotifier.addFood(food);
    Navigator.pop(context);
  }

  _addSubingredient(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _subingredients.add(text);
      });
      subingredientController.clear();
    }
  }

  _saveFood() {


    print('saveFood Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    // _currentFood.uid = authData.uid;

    _formKey.currentState.save();

    print('form saved');

    _currentFood.medium = _subingredients;

    uploadFoodAndImage(_currentFood, widget.isUpdating, _imageFile, _onFoodUploaded);

    print("name: ${_currentFood.title}");
    print("uid: ${_currentFood.uid}");
    //print("category: ${_currentFood.category}");
    print("subingredients: ${_currentFood.medium.toString()}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Add Art Piece')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit Artwork" : "Add Artwork",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? ButtonTheme(
              child: RaisedButton(
                onPressed: () => _getLocalImage(),
                child: Text(
                  'Add Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
                : SizedBox(height: 0),
            _buildUidField(),
            _buildArtistField(),
            _buildTitleField(),
            _buildSizeField(),
            _buildDescriptionField(),
            _buildPriceField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildSubingredientField(),
                ButtonTheme(
                  child: RaisedButton(
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                    onPressed: () => _addSubingredient(subingredientController.text),
                  ),
                )
              ],
            ),

            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(8),
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: _subingredients
                  .map(
                    (ingredient) => Card(
                  color: Colors.black54,
                  child: Center(
                    child: Text(
                      ingredient,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          //_currentFood.uid = authData.uid;
          _currentFood.uid = "test";
          _saveFood();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
//  _getProfileData() async {
//    final uid = await Prov.of(context).auth.getCurrentUID();
//    await Prov.of(context)
//        .db
//        .collection('userData')
//        .document(uid)
//        .get().then((result) {
//      user.homeCountry = result.data['homeCountry'];
//      user.admin = result.data['admin'];
//    });
//  }

  Future getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }
}
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//Future<User> _fetchUserInfo(String id) async {
//  User fetchedUser;
//  var snapshot = await Firestore.instance
//      .collection('user')
//      .document(id)
//      .get();
//  return User(snapshot);
//}
//void foo() async {
//  final user = await _fetchUserInfo(id);
//}
class User {
  String homeCountry;
  bool admin;

  User(this.homeCountry);

  Map<String, dynamic> toJson() => {
    'homeCountry': homeCountry,
    'admin': admin,
  };
}

