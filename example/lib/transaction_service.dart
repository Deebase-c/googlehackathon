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
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:http/http.dart' as http;
import 'package:square_in_app_payments_example/services/art_notifier.dart';
import 'package:square_in_app_payments_example/widgets/provider_widget.dart';


// Replace this with the server host you create, if you have your own server running
// e.g. https://server-host.com
String chargeServerHost = "https://us-central1-square-877d2.cloudfunctions.net";
String chargeUrl = "$chargeServerHost/squarePayments";


class ChargeException implements Exception {
  String errorMessage;
  ChargeException(this.errorMessage);
}

Future<void> chargeCard(CardDetails result) async {

//backend(result, _price);
  var chargeURL = "https://us-central1-square-877d2.cloudfunctions.net/squarePayments";
  var body = json.encode({"nonce": result.nonce
  });

  http.Response response;
  try{
    response= await http.post(
      chargeURL,
      body: body,
      headers:{
        "content-type": "text/plain",
  //  "Accept": "application/json",
    //"content-type": "application/json"
      },
    );
  }on SocketException catch (ex) {
    throw ChargeException(ex.message);
  }
  var responseBody = jsonDecode(response.body);
  if(response.statusCode ==200){
    print("Success");

//    final uid =
//    await Prov.of(context).auth.getCurrentUID();
//    await Prov.of(context)
//        .db
//        .collection('shippingDetails')
//        .document(uid)
//        .setData(user.toJson());

//
//    print("response.body");
//    print(response.body);
//    print("response.request");
//    print(response.request);
//
//    print("responseBody");
   print(responseBody);
//    print("responseBody.toString");
//    print(responseBody.toString());
    return;
  }else{
    print("Error");
  }
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

//_price(context){
//  var foodNotifier = Provider.of<FoodNotifier>(context);
//  var _price = foodNotifier.currentFood.price;
//}
//{
//  var body = jsonEncode({"nonce": result.nonce});
//  http.Response response;
//  try {
//    response = await http.post(chargeUrl, body: body, headers: {
//      "Accept": "application/json",
//      "content-type": "application/json"
//    });
//  } on SocketException catch (ex) {
//    throw ChargeException(ex.message);
//  }
//
//  var responseBody = json.decode(response.body);
//  if (response.statusCode == 200) {
//    return;
//  } else {
//    throw ChargeException(responseBody["errorMessage"]);
//  }
//}

//GOOD FROM SQUARE ONLINE **************************************
//Future<void> chargeCardAfterBuyerVerification(
//    BuyerVerificationDetails result) async {
//  var body = jsonEncode({"nonce": result.nonce, "token": result.token});
//  http.Response response;
//  try {
//    response = await http.post(chargeUrl, body: body, headers: {
//      "Accept": "application/json",
//      "content-type": "application/json"
//    });
//  } on SocketException catch (ex) {
//    throw ChargeException(ex.message);
//  }
//
//  var responseBody = json.decode(response.body);
//  if (response.statusCode == 200) {
//    return;
//  } else {
//    throw ChargeException(responseBody["errorMessage"]);
//  }
//}

//modified
Future<void> chargeCardAfterBuyerVerification(
    BuyerVerificationDetails result) async {

  var chargeURL = "https://us-central1-square-877d2.cloudfunctions.net/squarePayments";
  var body = jsonEncode({"nonce": result.nonce, "token": result.token});
  http.Response response;
  try {
    response = await http.post(
        chargeUrl,
        body: body,
        headers: {
          "content-type": "text/plain",
//      "Accept": "application/json",
//      "content-type": "application/json"
    });
  } on SocketException catch (ex) {
    throw ChargeException(ex.message);
  }

  var responseBody = json.decode(response.body);
  if (response.statusCode == 200) {
    return;
  } else {
    throw ChargeException(responseBody["errorMessage"]);
  }
}