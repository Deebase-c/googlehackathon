
import 'dart:async';

import 'package:square_in_app_payments_example/services/art_notifier.dart';
import 'package:square_in_app_payments_example/services/auth_notifier.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/art_form.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/artwork_api.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/detail.dart';
import 'package:square_in_app_payments_example/widgets/custom_dialog.dart';
import 'package:square_in_app_payments_example/widgets/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  User user = User("");
  bool _isAdmin = false;

  @override
  void initState() {
    var foodNotifier = Provider.of<FoodNotifier>(context, listen: false);
    getFoods(foodNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<AuthNotifier>(context);
    var foodNotifier = Provider.of<FoodNotifier>(context);

    Future<void> _refreshList() async {
      getFoods(foodNotifier);
    }

    print("building Feed");
    return Scaffold(
      appBar: AppBar(

        title: Text(
          //authNotifier.user != null ? authNotifier.user.displayName : "Feed",
            "Select Artwork To View Details"
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  title: "Click on Artwork to View Details",
                  description:
                  "1. Scroll through Artwork \n 2. Click on desired artwork to view details \n 3. Click on the shopping cart to purchase artwork",
                  primaryButtonText: "Got It.",
                  primaryButtonRoute: "/gotIt",
                  //secondaryButtonText: "Maybe Later",
                  //secondaryButtonRoute: "/anonymousSignIn",
                ),
              );

            },
          ),
        ],
      ),
      body: RefreshIndicator(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: ListTile(
                    title: Column(
                      children: <Widget>[
                        // Image.network(record.url),
                        Image.network(
                          foodNotifier.foodList[index].image != null
                              ? foodNotifier.foodList[index].image
                              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
//                              Text(
////                        "Title: {$foodNotifier.foodList[index].title} \n Artist: Ashley Mooney \n Medium: Resin \n Size: 20x16 ",
////                        //   "",
//                                "${foodNotifier.foodList[index].artist}\n${foodNotifier.foodList[index].title}" ,
//                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
//
//                              ),
                              Text(
                                "${foodNotifier.foodList[index].artist}",
                                style: TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                              Text(
                                'Title: ${foodNotifier.foodList[index].title}',
                                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                              ),
                              Text(
                                'Description: ${foodNotifier.foodList[index].description}',
                                style: TextStyle(fontSize: 12, fontStyle: FontStyle.normal),
                              ),
//                              Text(
//                                'Title: ${foodNotifier.currentFood.title}',
//                                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
//                              ),
                              // Text("test"),
                            ],
                          ),



                        ),
                      ],
                    ),
                    onTap: () {
                      foodNotifier.currentFood = foodNotifier.foodList[index];
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FoodDetail()));
                    },
                  ),
                ),
              ),
          itemCount: foodNotifier.foodList.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.white,
            ),
        ),
        onRefresh: _refreshList,
      ),
      floatingActionButton:
      FutureBuilder(
          future: _getProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
//                _userCountryController.text = user.homeCountry;
              _isAdmin = user.admin ?? false;
            }
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  adminFeature(),
                ],
              ),
            );
          }
      ),
//      FloatingActionButton(
//        onPressed: ()
//    {
//
//        foodNotifier.currentFood = null;
//      Navigator.of(context).push(
//        MaterialPageRoute(builder: (BuildContext context) {
//          return FoodForm(
//            isUpdating: false,
//          );
//        }),
//      );
//        },
//        child: Icon(Icons.add_a_photo),
//        foregroundColor: Colors.white,
//      ),
    );
  }

  Widget _buildArtistField() => FutureBuilder(
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

    return
      Text(
        "UID: ${authData.uid ?? 'Anonymous'}",
        style: TextStyle(fontSize: 20),
      );

  }
  _getProfileData() async {
    final uid = await Prov.of(context).auth.getCurrentUID();
    await Prov.of(context)
        .db
        .collection('userData')
        .document(uid)
        .get().then((result) {
      user.homeCountry = result.data['homeCountry'];
      user.admin = result.data['admin'];

    });
  }
  Widget adminFeature() {
    var foodNotifier = Provider.of<FoodNotifier>(context);

    if(_isAdmin == true) {
      return       FloatingActionButton(


        onPressed: ()
        {

          foodNotifier.currentFood = null;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => FoodForm(
                isUpdating: false,
              )),
          );
        },
        child: Icon(Icons.add_a_photo),
        foregroundColor: Colors.white,
      );
    } else {
      return Container();
    }
  }
}

class User {
  String homeCountry;
  bool admin;

  User(this.homeCountry);

  Map<String, dynamic> toJson() => {
    'homeCountry': homeCountry,
    'admin': admin,
  };
}







