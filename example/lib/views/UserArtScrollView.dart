//
//
//import 'UserUploadInteriorImage/UserPhotoDisplay.dart';
//import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
//class UserArtScrollView extends StatefulWidget {
//  @override
//  _UserArtScrollViewState createState() => _UserArtScrollViewState();
//}
//
//class _UserArtScrollViewState extends State<UserArtScrollView> {
//  Image imageFromPreferences;
//  double padValue = 0;
//  bool selectingmode = true;
//
//  List<Art> geodesList = <Art>[
////    Art("images/geode blue.jpg", "Blue", "Agate Rock"),
////    Art("images/geode flat purple.jpg", "Purple", "Amethyst"),
////    Art("images/geode gold.jpg", "Pink and Gold", "Quartz Selenite Crystal "),
////    Art("images/geode purple.jpg", "Purple", "Amethyst"),
////    Art("images/geode rose.jpg", "Rose Pink", "Quartz"),
////    Art("images/geode teal.jpg", "Teal", "Agate Rock"),
////    Art("images/geode aura quartz blue and gold.jfif", "Blue and Gold", "Aura Quartz"),
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
//
//
//
//
//
//    // Art("images/dark purple.jpg", "Dark Purple", "Amethyst"),
////    Art("images/teal crystal.jpg", "Teal", "Crystal"),
////    Art("images/pink crystal.png", "Pink", "Crystal"),
////    Art("images/Geode Grey.jpg", "White", "Quartz"),
//////    Art("images/crystal.jpg", "", "Crystal"),
////    Art("images/teal.png", "Teal", "Geode"),
////    Art("images/purple blue.jpg", "Pink and Gold", "Quartz Selenite Crystal "),
////    Art("images/geode purple.jpg", "Purple", "Amethyst"),
////    Art("images/geode rose.jpg", "Rose Pink", "Quartz"),
////    Art("images/teal geode.jpg", "Teal", "Agate Rock")
//  ];
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//
//          leading: selectingmode
//              ? IconButton(
//            icon: new Icon(Icons.arrow_back),
//            onPressed: () => Navigator.of(context).pop(),
//          ):null,
////              ? IconButton(
////            icon: const Icon(Icons.arrow_back),
////            onPressed: () {
////              setState(() {
////                selectingmode = false;
////                geodesList.forEach((p) => p.selected = false);
////              });
////            },
////          )
////              : null,
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
//                      debugPrint("image");
//                      debugPrint(geodesList[index].image);
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                              //    DefaultDisplayScreen(geode: geodesList[index].image)));
//                              UserPhotoDisplayScreen(geode: geodesList[index].image)));
////    Future.delayed(Duration(seconds: 3)).then((value) {
////      Navigator.push(
////          context,
////          MaterialPageRoute(
////              builder: (context) =>
////              //    DefaultDisplayScreen(geode: geodesList[index].image)));
////              UserPhotoDisplayScreen(geode: geodesList[index].image)));
////    });
//
////Navigator.popAndPushNamed(context);
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
