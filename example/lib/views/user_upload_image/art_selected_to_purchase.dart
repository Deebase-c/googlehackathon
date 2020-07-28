//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:square_in_app_payments_example/colors.dart';
//import 'package:square_in_app_payments_example/services/art_notifier.dart';
//import 'package:square_in_app_payments_example/views/customer_address_form.dart';
//import 'package:square_in_app_payments_example/widgets/cookie_button.dart';
//
//class ArtSelected extends StatefulWidget {
//  @override
//  _ArtSelectedState createState() => _ArtSelectedState();
//}
//
//class _ArtSelectedState extends State<ArtSelected> {
//  @override
//  Widget build(BuildContext context) => MaterialApp(
//
//    theme: ThemeData(canvasColor: Colors.transparent),
//    home: Scaffold(
//      appBar: AppBar(
//          title: Text("Purchase Art for Your Home"),
//          backgroundColor: Colors.blueGrey,
//          leading:
//          IconButton(
//            icon: Icon(Icons.arrow_back),
//            onPressed: () =>
//
//                Navigator.of(context, rootNavigator: true).pop(context),
//
////          Navigator.push(
////              context,
////              MaterialPageRoute(
////                  builder: (context) =>
////                  //    DefaultDisplayScreen(geode: geodesList[index].image)));
////                  Feed())),
//          )
//      ),
//      backgroundColor: mainBackgroundColor,
//      //key: BuySheet.scaffoldKey,
//      body: Builder(
//        builder: (context) => Center(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: [
//                Container(
////                  child: Image(image: AssetImage(
////                      "assets/iconCookie.png"
////                      )),
//                  child: imageOrientation(context),
//                ),
//                Container(
////                  child: Text(
////                    'Super Cookie',
////                    style: TextStyle(
////                      color: Colors.white,
////                      fontSize: 28,
////                    ),
////                  ),
//                  child: textBuild(context),
//                ),
//                Container(
//                  child: Text(
//                    "Instantly gain special powers \nwhen ordering a super cookie",
//                    style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 16,
//                    ),
//                  ),
//                ),
//                Container(
//                  width: 200,
//                  //margin: EdgeInsets.only(top: 32),
//                  //   child: CookieButton(text: "Buy", onPressed: _showOrderSheet),
//                  child: CookieButton(text: "Buy", onPressed:(){
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => AddressScreen()));
//                  }
//                  ),
//                  // AddressScreen
//                ),
//              ],
//            )),
//      ),
//    ),
//  );
//
//  // ignore: type_annotate_public_apis
//  imageOrientation(BuildContext context) {
//    var foodNotifier = Provider.of<FoodNotifier>(context);
//    if (MediaQuery
//        .of(context)
//        .orientation == Orientation.portrait) {
//      return
//        Image.network(
//          foodNotifier.currentFood.image != null
//              ? foodNotifier.currentFood.image
//              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
//          width: MediaQuery
//              .of(context)
//              .size
//              .width,
//          height: 250,
//          fit: BoxFit.fitWidth,
//        );
//    } else if (MediaQuery
//        .of(context)
//        .orientation == Orientation.landscape) {
//      return
//        Image.network(
//          foodNotifier.currentFood.image != null
//              ? foodNotifier.currentFood.image
//              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
//          width: MediaQuery
//              .of(context)
//              .size
//              .width,
//          height: ((MediaQuery
//              .of(context)
//              .size
//              .height) / 4),
//          fit: BoxFit.fitHeight,
//        );
//    }
//  }
//
//  textBuild(BuildContext context){
//    var foodNotifier = Provider.of<FoodNotifier>(context);
//    return Padding(
//      padding: const EdgeInsets.only(top:50.0),
//      child: Text("Price: ${foodNotifier.currentFood.price}",style: TextStyle(color: Colors.blueGrey ,fontStyle: FontStyle.italic), textScaleFactor: 1.8,),
//    );
//  }
//}
