/*
 Copyright 2018 Square Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments_example/services/art_notifier.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/art_form.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/artwork_api.dart';
import 'package:square_in_app_payments_example/widgets/custom_dialog.dart';
import 'package:square_in_app_payments_example/widgets/provider_widget.dart';
import '../colors.dart';
import 'cookie_button.dart';
import 'buy_sheet.dart';

enum PaymentType { cardPayment, googlePay, applePay }

final int cookieAmount = 2;

//var foodNotifier = Provider.of<FoodNotifier>(context);
//final int cookieAmount = foodNotifier.currentFood.price;


String getCookieAmount() => (cookieAmount / 100).toStringAsFixed(2);


class OrderSheet extends StatefulWidget {

  final bool googlePayEnabled;
  final bool applePayEnabled;
  OrderSheet({this.googlePayEnabled, this.applePayEnabled});

  @override
  _OrderSheetState createState() => _OrderSheetState();
}


class _OrderSheetState extends State<OrderSheet> {
  User user = User("","","","","");

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userAddressController = TextEditingController();
  final TextEditingController _userCityController = TextEditingController();
  final TextEditingController _userPostalController = TextEditingController();
  final TextEditingController _userCountryController = TextEditingController();
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0))),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: _title(context),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: 300,
                maxHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                 // _ShippingInformation(),
                  FutureBuilder(
                    future: Prov.of(context).auth.getCurrentUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        debugPrint("");
                       // return _ShippingInformation();
                        return displayUserInformation(context, snapshot);

                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  _LineDivider(),
                  _PaymentTotal(),
                  _LineDivider(),
                  _RefundInformation(),
                  _payButtons(context),
                ]),
          ),
        ]),
  );

  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;
    return
//      Scaffold(
//
//      body: Center(
//        child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[


          FutureBuilder(
              future: _getProfileData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  _userNameController.text = user.userName;
                  _userAddressController.text = user.streetAddress;
                  _userCityController.text = user.homeCity;
                  _userCountryController.text = user.homeCountry;
                  _userPostalController.text = user.homePostalCode;
                  //  _isAdmin = user.admin ?? false;
                }
                return Container(
                  child: Column(
                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child:
//                        Text(
//                          "Home City: ${_userCityController.text}",
//                          style: TextStyle(fontSize: 20),
//                        ),
//
//                      ),
                      Text(
                        // "Ashley Mooney",
                        "${_userNameController.text}",

                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 6),
                      ),
                      Text(
                        "${_userAddressController.text}\n${_userCityController.text}, ${_userCountryController.text} , ${_userPostalController.text}",
                        // ${user.homeCountry}

                        style: TextStyle(fontSize: 16, color: subTextColor),
                      ),
                    //  adminFeature(),
                    ],
                  ),
                );
              }
          ),



        ],

      );

    //     ),
    // );

  }
  _getProfileData() async {
    final uid = await Prov.of(context).auth.getCurrentUID();
    await Prov.of(context)
        .db
        .collection('userData')
        .document(uid)
        .get().then((result) {
      user.userName = result.data['userName'];
      user.streetAddress = result.data['streetAddress'];
      user.homeCity = result.data['homeCity'];
      user.homePostalCode = result.data['homePostalCode'];
      user.homeCountry = result.data['homeCountry'];
      user.admin = result.data['admin'];

    });
  }

  Widget _title(context) =>
      Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
                color: closeButtonColor)),
        Container(
          child: Expanded(
            flex:1,
            child: Text(
              "Place your order",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(right: 56)),
      ]);

  Widget _payButtons(context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      CookieButton(
        text: "Edit Shipping Details",
        onPressed:(){
          Navigator.pop(context);
         // _userEditBottomSecondSheet(context);
        }
      ),
      CookieButton(
        text: "Pay with card",
        onPressed: () {
//          Navigator.pop(context, PaymentType.cardPayment);
          if (_userAddressController.text == "") {
            debugPrint("Please Enter an Address");
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                title: "Shipping Info Error",
                description:
                "Please enter a valid Shipping Address",
                primaryButtonText: "Got It.",
                primaryButtonRoute: "/gotIt",

                //secondaryButtonText: "Maybe Later",
                //secondaryButtonRoute: "/anonymousSignIn",
              ),
            );
          }else if (_userNameController.text == ""){
            debugPrint("Please Enter a Buyer Name");
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                title: "Shipping Info Error",
                description:
                "Please enter a valid Buyer Name",
                primaryButtonText: "Got It.",
                // primaryButtonRoute: "/gotIt",

                //secondaryButtonText: "Maybe Later",
                //secondaryButtonRoute: "/anonymousSignIn",
              ),
            );
          }
          else if (_userCityController.text == ""){
            debugPrint("Please Enter a City");
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                title: "Shipping Info Error",
                description:
                "        Please enter a valid City        ",
                primaryButtonText: "Got It.",
                // primaryButtonRoute: "/gotIt",

                //secondaryButtonText: "Maybe Later",
                //secondaryButtonRoute: "/anonymousSignIn",
              ),
            );
          }
          else if (_userCountryController.text == ""){
            debugPrint("Please Enter a Province / State");
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                title: "Shipping Info Error",
                description:
                "Please enter a valid Province / State",
                primaryButtonText: "Got It.",
                // primaryButtonRoute: "/gotIt",

                //secondaryButtonText: "Maybe Later",
                //secondaryButtonRoute: "/anonymousSignIn",
              ),
            );
          }
          else if ((_userPostalController.text == "")||(_userPostalController.text == "")) {
            debugPrint("Please Enter a Postal Code");
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                title: "Shipping Info Error",
                description:
                "Please enter a valid Postal Code",
                primaryButtonText: "Got It.",
                // primaryButtonRoute: "/gotIt",

                //secondaryButtonText: "Maybe Later",
                //secondaryButtonRoute: "/anonymousSignIn",
              ),
            );
          }else
          {
            Navigator.pop(context, PaymentType.cardPayment);
          }
        },
      ),
//      Container(
//        height: 64,
//        width: MediaQuery.of(context).size.width * .4,
//        child: RaisedButton(
//          onPressed: googlePayEnabled || applePayEnabled
//              ? () {
//            if (Platform.isAndroid) {
//              Navigator.pop(context, PaymentType.googlePay);
//            } else if (Platform.isIOS) {
//              Navigator.pop(context, PaymentType.applePay);
//            }
//          }
//              : null,
//          child: Image(
//              image: (Theme.of(context).platform == TargetPlatform.iOS)
//                  ? AssetImage("assets/applePayLogo.png")
//                  : AssetImage("assets/googlePayLogo.png")),
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(30.0)),
//          color: Colors.black,
//        ),
//      ),
    ],
  );
  void _userEditBottomSecondSheet(BuildContext context) {
    showModalBottomSheet(

      isScrollControlled: true,
      enableDrag: true,

      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext bc) => Container(

        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        height: MediaQuery.of(context).size.height * .65,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Shipping Details"),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    color: Colors.blueGrey,
                    iconSize: 25,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _userNameController,
                      maxLength: 30,
                      decoration: InputDecoration(
                        helperText: "Buyer Name",
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _userAddressController,
                      decoration: InputDecoration(
                        helperText: "Apt # , Street Address",
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: TextField(
                          controller: _userCityController,
                          decoration: InputDecoration(
                            helperText: "City",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: TextFormField(
                          controller: _userCountryController,
                          maxLength: 15,
                          decoration: InputDecoration(
                            helperText: "Province / State",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _userPostalController,
                      maxLength: 6,
                      decoration: InputDecoration(
                        helperText: "Postal Code",
                      ),
                    ),
                  )
                ],
              ),
//                Row(
//                  children: [
//                    Expanded(
//                      child: TextField(
//                        controller: _userCountryController,
//                        decoration: InputDecoration(
//                          helperText: "Country",
//                        ),
//                      ),
//                    )
//                  ],
//                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(

                    child: Text('Next'),
                    color: Colors.blueGrey,
                    textColor: Colors.white,
                    onPressed: () async {
                      user.userName = _userNameController.text;
                      user.streetAddress = _userAddressController.text;
                      user.homeCity = _userCityController.text;
                      user.homePostalCode = _userPostalController.text;
                      user.homeCountry = _userCountryController.text;
                      setState(() {
                        user.userName = _userNameController.text;
                        _userAddressController.text = user.streetAddress;
                        _userCityController.text = user.homeCity;
                        _userPostalController.text = user.homePostalCode;
                        _userCountryController.text = user.homeCountry;
                      });
                      final uid =
                      await Prov.of(context).auth.getCurrentUID();
                      await Prov.of(context)
                          .db
                          .collection('userData')
                          .document(uid)
                          .setData(user.toJson());
                      Navigator.of(context).pop();
                      OrderSheet();
                    },
                  )
                ],
              ),
            ],
          ),

        ),
      ),
    );

  }

}


class _ShippingInformation extends StatelessWidget {

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userAddressController = TextEditingController();
  final TextEditingController _userCityController = TextEditingController();
  final TextEditingController _userPostalController = TextEditingController();
  final TextEditingController _userCountryController = TextEditingController();

  @override
  Widget build(BuildContext context) => Row(

    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(padding: EdgeInsets.only(left: 30)),
      Text(
        "Ship to",
        style: TextStyle(fontSize: 16, color: mainTextColor),
      ),
      Padding(padding: EdgeInsets.only(left: 30)),

      Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

             //  _getUserNameData(),
//            FutureBuilder(
//
//            ),
            Text(
             // "Ashley Mooney",
              "${_userNameController.text}",

              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            Text(
              // "Ashley Mooney",
              "${_userAddressController.text}",

              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 6),
            ),
            Text(
              "${_userCityController.text}, ${_userCountryController.text}, ${_userPostalController.text}",
 // ${user.homeCountry}

style: TextStyle(fontSize: 16, color: subTextColor),
              textAlign: TextAlign.center,
            ),
          ]),
    ],
  );


}

class _LineDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Divider(
        height: 1,
        color: dividerColor,
      ));
}

class _PaymentTotal extends StatelessWidget {


  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(padding: EdgeInsets.only(left: 30)),
      Text(
        "Total",
        style: TextStyle(fontSize: 16, color: mainTextColor),
      ),
      Padding(padding: EdgeInsets.only(right: 47)),
      textBuild(context),
//      Text(
//        "\$${getCookieAmount()}",
//        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//        textAlign: TextAlign.center,
//      ),
    ],
  );
  // ignore: type_annotate_public_apis
  textBuild(BuildContext context){
    var foodNotifier = Provider.of<FoodNotifier>(context);
    return Text("Price: ${foodNotifier.currentFood.price}",style: TextStyle(color: Colors.blueGrey ,fontStyle: FontStyle.italic), textScaleFactor: 1.8,);
  }
}

class _RefundInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FittedBox(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 30.0, right: 30.0),
          width: MediaQuery.of(context).size.width - 60,
          child: Text(
            "You can refund this transaction by sending an email request to ashleymooney03@gmail.com (Within 2 days of purchase).",
            style: TextStyle(fontSize: 12, color: subTextColor),
          ),
        ),
      ],
    ),
  );
}

class User {
  String userName;
  String streetAddress;
  String homeCity;
  String homePostalCode;
  String homeCountry;
  bool admin;

  User(this.userName,this.streetAddress, this.homeCity, this.homePostalCode, this.homeCountry );

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'streetAddress': streetAddress,
    'homeCity': homeCity,
    'homePostalCode': homePostalCode,
    'homeCountry': homeCountry,
    'admin': admin,
  };
}