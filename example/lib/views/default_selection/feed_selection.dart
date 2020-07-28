

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments_example/services/art_notifier.dart';
import 'package:square_in_app_payments_example/services/auth_notifier.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/artwork_api.dart';
import 'package:square_in_app_payments_example/views/default_selection/default_screenshot.dart';
import 'package:square_in_app_payments_example/widgets/provider_widget.dart';

class FeedSelection extends StatefulWidget {
  @override
  _FeedSelectionState createState() => _FeedSelectionState();
}

class _FeedSelectionState extends State<FeedSelection> {
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
         // authNotifier.user != null ? authNotifier.user.displayName : "Feed",
          //  _buildArtistField();
          "Artwork Selection",
        ),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.exit_to_app),
//            onPressed: () {
//
//            },
//          ),
        ],
      ),
      body: RefreshIndicator(
        child: ListView.separated(
          // ignore: unnecessary_new
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
//                      foodNotifier.currentFood = foodNotifier.foodList[index];
//                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
//                        return FoodDetail();
//                      }));
                      foodNotifier.currentFood = foodNotifier.foodList[index];
                      debugPrint("image");
                      debugPrint(foodNotifier.foodList[index].image);
                      Navigator.push(
                          context,MaterialPageRoute(
                          builder: (context) =>
                              ScreenshotDefaultDisplayScreen(geode: foodNotifier.foodList[index].image)));
                    },
                  ),
                ),
              ),
          itemCount: foodNotifier.foodList.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.black,
            ),
        ),
        onRefresh: _refreshList,
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          foodNotifier.currentFood = null;
//          Navigator.of(context).push(
//            MaterialPageRoute(builder: (BuildContext context) {
//              return FoodForm(
//                isUpdating: false,
//              );
//            }),
//          );
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
}


//
//import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:travel_budget/views/DefaultSelection/DefaultScreenshot.dart';
//
//class ArtScrollView extends StatefulWidget {
//  @override
//  _ArtScrollViewState createState() => _ArtScrollViewState();
//}
//
//class _ArtScrollViewState extends State<ArtScrollView> {
//  Image imageFromPreferences;
//  double padValue = 0;
//  bool selectingmode = true;
//
//  List<Art> geodesList = <Art>[
//
//    Art("images/egate.png", "Blue", "Geode"),
//    Art("images/Transparent Grey Geode.png", "Grey", "Geode"),
//    Art("images/Transparent Purple Geode.png", "Purple", "Amethyst"),
//    Art("images/light pink agate.png", "Pink", "Agate"),
//    Art("images/light purple agate.png", "Purple", "Agate"),
//    Art("images/brown.png", "Brown", "Agate"),
//    Art("images/green agate.png", "Green", "Agate"),
//    Art("images/light blue geode.png", "Light Blue", "Agate"),
//    Art("images/orange and black.png", "Orange", "Agate"),
//    Art("images/pink geode.png", "Pink", "Agate"),
//    Art("images/purple agate.png", "Purple", "Agate"),
//    Art("images/purple detailed.png", "Purple", "Agate"),
//    Art("images/royal blue.png", "Royal Blue", "Agate"),
//    Art("images/teal.png", "Teal", "Agate"),
//    Art("images/yellow.png", "Yellow", "Agate"),
//    Art("images/red geode.png", "Red", "Agate"),
//
//
//
//
//
//
//  ];
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          leading: selectingmode
//              ?
//          IconButton(
//            icon: new Icon(Icons.arrow_back),
//            onPressed: () => Navigator.of(context).pop(),
//          )
////          IconButton(
////            icon: const Icon(Icons.arrow_back),
////            onPressed: () {
////              setState(() {
////                selectingmode = false;
////                geodesList.forEach((p) => p.selected = false);
////              });
////            },
////          )
//              : null,
//          backgroundColor: Colors.blueGrey,
//          title: Text("Select Artwork"),
//          actions: <Widget>[
////            IconButton(
////              icon: Icon(
////                Icons.question_answer,
////                color: Colors.white,
////              ),
////              onPressed: () {
////              },
////            )
//          ],
//        ),
//        body: Center(
//          child: ListView(
//            scrollDirection: Axis.vertical,
//            children: List.generate(geodesList.length, (index) {
//              return
////              Container(
////           width: 450,
//                Container(
//                  //  height: 350,
//                  //  width: 350,
//                  child: InkWell(
//                    onTap: () {
//                      //  debugPrint(geodesList[index].image);
//                      geodesList.forEach((p) => p.selected = false);
//
//                      setState(() {
//                        if (selectingmode) {
//                          geodesList[index].selected =
//                          !geodesList[index].selected;
//                        }
//                      });
//
//
////                          return FutureBuilder<String>(
////                            future: _future(),
////                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
////                              if (snapshot.connectionState == ConnectionState.done &&
////                                  null != snapshot.data) {
////                                //print(snapshot.data.path);
////                                addStringToSharedPreferences();
////                                return
////                                  this.builder(context, snapshot);
////                                //  Image.asset(snapshot.data,);
////                              } else if (null != snapshot.error) {
////                                return const Text(
////                                  'Error Picking Image',
////                                  textAlign: TextAlign.center,
////                                );
////                              } else {
////                                return const Text(
////                                  'No Image Selected',
////                                  textAlign: TextAlign.center,
////                                );
////                              }
////                            },
////                          );
//
//                      Navigator.push(
//                    context,MaterialPageRoute(
//                              builder: (context) =>
//                              ScreenshotDefaultDisplayScreen(geode: geodesList[index].image)));
                      //(geode: geodesList[index].image)));
//Navigator.popAndPushNamed(context);
//                    },
//                    child: new Card(
//                      child: Wrap(
//                        children: <Widget>[
//                          Center(
//                            child: Image.asset(
//                              geodesList[index].image,
//                              //height: 300,
//                            ),
//                          ),
//
//                          Row(
//                            children: <Widget>[
//                              Text(
//                                geodesList[index].color,
//                                style: TextStyle(
//                                    fontSize: 22, fontStyle: FontStyle.normal),
//                              ),
//                            ],
//                          ),
//                          Row(
//                            children: <Widget>[
//                              Padding(
//                                padding: const EdgeInsets.all(5.0),
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.end,
//                                  children: <Widget>[
//                                    (selectingmode)
//                                        ? ((geodesList[index].selected)
//                                        ? Icon(Icons.check_box)
//                                        : Icon(Icons.check_box_outline_blank))
//                                        : null
//                                  ],
//                                ),
//                              ),
//                              Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: <Widget>[
//                                  Text(
//                                    geodesList[index].stone,
//                                    style: TextStyle(
//                                        fontSize: 16,
//                                        fontStyle: FontStyle.italic,
//                                        color: Colors.blueGrey),
//                                  ),
//                                ],
//                              ),
//                            ],
//                          ),
////
////)
//                        ],
//                      ),
//                    ),
//                  ),
//                );
//            }),
//          ),
//        ),
////        floatingActionButton: FloatingActionButton(
////            backgroundColor: Colors.blueGrey,
////            child: Icon(FontAwesomeIcons.arrowRight, color: Colors.white),
////            onPressed: () {
////              // build(context);
////              //addStringToSharedPreferences();
////              //Navigator.pop(context);
////            }),
//      ),
//    );
//  }
//
//}
//
////class SharedPrefUtils {
////
////  static addStringToSharedPreferences(String key, String artPiece) async {
////    final SharedPreferences pref = await SharedPreferences.getInstance();
////    pref.setString(key, artPiece);
////  }
////
////  static getStringValuesRead(String key) async {
////    final SharedPreferences pref = await SharedPreferences.getInstance();
////    return pref.getString(key);
////  }
////
////}
//
//class Art {
//  final String image;
//  final String color;
//  final String stone;
//  bool selected = false;
//
//  Art(this.image, this.color, this.stone);
//}
//
//class Paint {
//  final String imageVal;
//  final String title;
//  final String subheading;
//  bool selected = false;
//
//  Paint(this.imageVal, this.title, this.subheading);
//}
//
//
