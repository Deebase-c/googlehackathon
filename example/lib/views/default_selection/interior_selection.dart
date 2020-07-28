import 'dart:async';

import 'package:square_in_app_payments_example/views/default_selection/feed_selection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Paint {
  final String imageVal;
  final String title;
  final String subheading;
  bool selected = false;

  Paint(this.imageVal, this.title, this.subheading);
}

class InteriorScrollView extends StatefulWidget {
  // receive data from the FirstScreen as a parameter

  @override
  _InteriorScrollViewState createState() => _InteriorScrollViewState();
}

class _InteriorScrollViewState extends State<InteriorScrollView> {
//   final String text;

  double padValue = 0;
//  File templateFile;
  bool selectingmode = true;
  String roomLayout;

  List<Paint> paints = <Paint>[
    Paint("assets/fireplace.jpg", 'Living Room', "Country Interior"),
    Paint("assets/Living Room Yellow.jpg", 'Living Room', "Yellow Interior"),
    Paint("assets/Living Room White Couch.png", 'Living Room', "White Interior"),
    Paint("assets/Living Room White Leather.jpg", 'Living Room', "White Interior"),
    Paint("assets/Living Room All White.jpg", 'Living Room', "White Interior"),
    Paint("assets/Living Room White Wall.jpg", 'Living Room', "White Interior"),
    Paint("assets/white everything.jpg", 'Living Room', "White Interior"),
    Paint("assets/White wall beige couch.jfif", 'Living Room', "White Interior"),
    Paint("assets/white walls greay couch.jpg", 'Living Room', "White Interior"),
    Paint("assets/Living Room Beige Everything.jpg", 'Living Room', "Beige Interior"),
    Paint("assets/Living Room All Beige.jpg", 'Living Room', "Beige Interior"),
    Paint("assets/Living Room Beige Leather.png", 'Living Room', "Beige Interior"),
    Paint("assets/Living Room Beige.jpg", 'Living Room', "Beige Interior"),
    Paint("assets/Living Room Beige Couch.jpg", 'Living Room', "Beige Interior"),
    Paint("assets/Living Room Beige Wall.jpg", 'Living Room', "Beige Interior"),
    Paint("assets/Living Room Brick Beige Couch.jpg", 'Living Room', "Beige Interior"),
    Paint("assets/Living Room Grey Couch.png", 'Living Room', "Grey Interior"),
    Paint("assets/Living Room Grey Everything.jpg", 'Living Room', "Grey Interior"),
    Paint("assets/Living Room All Grey.jpg", 'Living Room', "Grey Interior"),
    Paint("assets/Living Room Conrete Grey Couch.jpg", 'Living Room', "Grey Interior"),
    Paint("assets/Living Room Dark Grey.jpg", 'Living Room', "Grey Interior"),
    Paint("assets/Living Room Blue Wall.jpg", 'Living Room', "Blue Interior"),
    Paint("assets/Living Room Pink.png", 'Living Room', "Pink Interior"),
    Paint("assets/Living Room Pink Wall.jpg", 'Living Room', "Pink Interior"),
    Paint("assets/Living Room Pink Chair.jpg", 'Living Room', "Pink Interior"),
    Paint("assets/black walls yellow couch.jpg", 'Living Room', "Black Interior"),
    Paint("assets/Living Room Bamboo.jpg", 'Living Room', "Bamboo Interior"),
    Paint("assets/Living Room Beach.jpg", 'Living Room', "Beachy Interior"),
    Paint("assets/Living Room Brick Brown Couch.jpg", 'Living Room', "Brick Interior"),
    Paint("assets/Living Room Concrete.jpg", 'Living Room', "Concrete Interior"),
    Paint("assets/Living Room Fancy.jpg", 'Living Room', "Hotel Interior"),
    Paint("assets/Living Room Flowers.jpg", 'Living Room', "Flowery Interior"),
    Paint("assets/Living Room Gold.png", 'Living Room', "Gold Interior"),
    Paint("assets/Living Room Green Couch.jpg", 'Living Room', "Green Interior"),
    Paint("assets/Living Room Greenery.jpg", 'Living Room', "Green Interior"),
    Paint("assets/Living Room Hotel.jpg", 'Living Room', "Hotel Interior"),
    Paint("assets/Living Room Marble.jpg", 'Living Room', "Marble Interior"),
    Paint("assets/Living Room Open.jfif", 'Living Room', "Modern Interior"),
    Paint("assets/Living Room Plain.jpg", 'Living Room', "Plain Interior"),
    Paint("assets/Living Room Red Couch.jpg", 'Living Room', "Red Interior"),
    Paint("assets/Living Room Retro.jpg", 'Living Room', "Retro Interior"),
    Paint("assets/Living Room Rustic.jpg", 'Living Room', "Rustic Interior"),
    Paint("assets/Living Room Wood.jpg", 'Living Room', "Wooden Interior"),
    Paint("assets/Blue Grey Wall.jpg", 'Living Room', "Blue Grey Interior"),
    Paint("assets/Yellow Walls Yellow Couch.jpg", 'Living Room', "Yellow Interior"),
    Paint("assets/Living Room Brick Wall Yellow Couch.jpeg", 'Living Room', "Yellow Interior")

  ];

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: selectingmode
              ?
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          )
//          IconButton(
//            icon: const Icon(Icons.arrow_back),
//            onPressed: () {
//              addStringToSharedPreferences();
//              getStringValuesRead();
//              setState(() {
//                selectingmode = false;
//                paints.forEach((p) => p.selected = false);
//              });
//            },
//          )
              : null,
          backgroundColor: Colors.blueGrey,
          title: Text("Select an Interior Template"),
          actions: <Widget>[

          ],
        ),
        body: Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: List.generate(paints.length, (index) => Container(
                  //  height: 350,
                  //  width: 350,
                  child: InkWell(
                    highlightColor: Colors.lightBlue,
                    onTap: () {
//                  print("${paints[index].imageVal}");
                      // ignore: avoid_function_literals_in_foreach_calls
                      paints.forEach((p) => p.selected = false);

                      setState(() {
                        if (selectingmode) {
                          paints[index].selected = !paints[index].selected;
                        }
                      });
                      roomLayout = paints[index].imageVal;
                      removeValues();
                      addStringToSharedPreferences();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            // builder: (context) => FinalScreen(background: paints[index].imageVal ,)));
                            //  builder: (context) => ArtScrollView()));
                      builder: (context) => FeedSelection()));
                    },
                    child:  Card(
                      child: Wrap(
                        children: <Widget>[
                          Center(
                            child: Image.asset(
                              paints[index].imageVal,
                              //height: 300,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                paints[index].title,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.blueGrey),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    (selectingmode)
                                        ? ((paints[index].selected)
                                        ? Icon(Icons.check_box)
                                        : Icon(Icons.check_box_outline_blank))
                                        : null
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    paints[index].subheading,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            child: Icon(FontAwesomeIcons.arrowRight, color: Colors.white),
            onPressed: () {}),
      ),
    );
  // ignore: type_annotate_public_apis
  addStringToSharedPreferences() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("stringValue", roomLayout);
  }


  // ignore: type_annotate_public_apis
  removeValues() async {
    var prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.remove("stringValue");
  }
}

Future<String> getStringValuesRead() async {
  var prefs = await SharedPreferences.getInstance();
  //Return String
  var stringValue = prefs.getString('stringValue');
  return stringValue;
}