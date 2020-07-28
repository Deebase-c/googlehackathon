import 'dart:async';
import 'dart:convert';
//import 'dart:js';
import 'package:built_collection/built_collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments_example/services/art_notifier.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/detail.dart';
import 'package:square_in_app_payments_example/views/customer_address_form.dart';
import 'package:square_in_app_payments_example/views/feed.dart';
import 'package:square_in_app_payments_example/views/user_upload_image/contact_services.dart';
import 'package:square_in_app_payments_example/views/user_upload_image/quote_form.dart';
import 'package:uuid/uuid.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/google_pay_constants.dart'
as google_pay_constants;
import '../colors.dart';
import '../config.dart';
import '../transaction_service.dart';
import 'cookie_button.dart';
import 'dialog_modal.dart';
// We use a custom modal bottom sheet to override the default height (and remove it).
import 'modal_bottom_sheet.dart' as custom_modal_bottom_sheet;
import 'order_sheet.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:square_in_app_payments_example/widgets/cookie_button.dart';

import 'package:square_in_app_payments_example/widgets/provider_widget.dart';
import 'package:square_in_app_payments_example/models/users.dart';
//import 'package:intl/intl.dart';

enum ApplePayStatus { success, fail, unknown }

class BuySheet extends StatefulWidget {

  final bool applePayEnabled;
  final bool googlePayEnabled;
  final String squareLocationId;
  final String applePayMerchantId;
  static final GlobalKey<ScaffoldState> scaffoldKey =
  GlobalKey<ScaffoldState>();

  BuySheet(
      {this.applePayEnabled,
        this.googlePayEnabled,
        this.applePayMerchantId,
        this.squareLocationId,
      });



  @override
  BuySheetState createState() => BuySheetState();

}





class BuySheetState extends State<BuySheet> {

  User user = User("","","","","");
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userAddressController = TextEditingController();
  final TextEditingController _userCityController = TextEditingController();
  final TextEditingController _userPostalController = TextEditingController();
  final TextEditingController _userCountryController = TextEditingController();

  // ignore: type_annotate_public_apis, prefer_typing_uninitialized_variables
//  var price= 1;

  //final price = Provider.of<FoodNotifier>(context).currentFood.price;


  ApplePayStatus _applePayStatus = ApplePayStatus.unknown;

  bool get _chargeServerHostReplaced => chargeServerHost != "https://us-central1-square-877d2.cloudfunctions.net/squarePayments";

  //bool get _squareLocationSet => widget.squareLocationId != "	S5RHS8F65X2HX";
  bool get _squareLocationSet => widget.squareLocationId != "X7ZKSMN4J1W4T";

  bool get _applePayMerchantIdSet => widget.applePayMerchantId != "REPLACE_ME";

  void _showOrderSheet() async {
    //var uid = "${_userAddressController.text.toString()}";
  var uid = await Prov.of(context).auth.getCurrentUID();
//var uid = DateTime.now();
    //var uid = 7.toString();
    debugPrint('Child widget: initState(), address = $uid');
    var price = int.parse(Provider.of<FoodNotifier>(context, listen: false).currentFood.price);
    debugPrint('Child widget: initState(), price = $price');

    var selection =
    await custom_modal_bottom_sheet.showModalBottomSheet<PaymentType>(
        context: BuySheet.scaffoldKey.currentState.context,
        builder: (context) => OrderSheet(
          applePayEnabled: widget.applePayEnabled,
          googlePayEnabled: widget.googlePayEnabled,
        ));

    switch (selection) {

      case PaymentType.cardPayment:
      // call _onStartCardEntryFlow to start Card Entry without buyer verification (SCA)
       await _onStartCardEntryFlow(price, uid);
        // OR call _onStartCardEntryFlowWithBuyerVerification to start Card Entry with buyer verification (SCA)
        // NOTE this requires _squareLocationSet to be set
       //  await _onStartCardEntryFlowWithBuyerVerification(price,uid);
        break;
      case PaymentType.googlePay:
        if (_squareLocationSet && widget.googlePayEnabled) {
          _onStartGooglePay();
        } else {
          _showSquareLocationIdNotSet();
        }
        break;
      case PaymentType.applePay:
        if (_applePayMerchantIdSet && widget.applePayEnabled) {
          _onStartApplePay();
        } else {
          _showapplePayMerchantIdNotSet();
        }
        break;
    }
  }

  void printCurlCommand(String nonce, String verificationToken) {
    var hostUrl = 'https://connect.squareup.com';
    if (squareApplicationId.startsWith('sandbox')) {
      hostUrl = 'https://connect.squareupsandbox.com';
    }
    var uuid = Uuid().v4();

    if (verificationToken == null) {
      print(
          'curl --request POST $hostUrl/v2/payments \\'
              '--header \"content-type: text/plain\" \\'
              //'--header \"Authorization: Bearer EAAAEAn6dXKCviQvVhjuT0tieG1x9Bp0Gh3lwkxmbmZ7jBuZzI9UjDjZOSBvlvkt\" \\'
              //'--header \"Accept: application/json\" \\'
              '--data \'{'
              '\"idempotency_key\": \"$uuid\",'
              '\"amount_money\": {'
              '\"amount\": $cookieAmount,'
              '\"currency\": \"USD\"},'
              '\"source_id\": \"$nonce\"'
              '}\'');
    } else {
      print('curl --request POST $hostUrl/v2/payments \\'
          '--header \"content-type: text/plain\" \\'
          //'--header \"Authorization: Bearer EAAAEAn6dXKCviQvVhjuT0tieG1x9Bp0Gh3lwkxmbmZ7jBuZzI9UjDjZOSBvlvkt\" \\'
          //'--header \"Accept: application/json\" \\'
          '--data \'{'
          '\"idempotency_key\": \"$uuid\",'
          '\"amount_money\": {'
          '\"amount\": $cookieAmount,'
          '\"currency\": \"USD\"},'
          '\"source_id\": \"$nonce\",'
          '\"verification_token\": \"$verificationToken\"'
          '}\'');
    }
  }

  void _showUrlNotSetAndPrintCurlCommand(String nonce,
      {String verificationToken}) {
    String title;
    if (verificationToken != null) {
      title = "Nonce and verification token generated but not charged";
    } else {
      title = "Nonce generated but not charged";
    }
    showAlertDialog(
        context: BuySheet.scaffoldKey.currentContext,
        title: title,
        description:
        "Check your console for a CURL command to charge the nonce, or replace CHARGE_SERVER_HOST with your server host.");
    printCurlCommand(nonce, verificationToken);
  }

  void _showSquareLocationIdNotSet() {
    showAlertDialog(
        context: BuySheet.scaffoldKey.currentContext,
        title: "Missing Square Location ID",
        description:
        "To request a Google Pay nonce, replace squareLocationId in main.dart with a Square Location ID.");
  }

  void _showapplePayMerchantIdNotSet() {
    showAlertDialog(
        context: BuySheet.scaffoldKey.currentContext,
        title: "Missing Apple Merchant ID",
        description:
        "To request an Apple Pay nonce, replace applePayMerchantId in main.dart with an Apple Merchant ID.");
  }

  void _onCardEntryComplete() {
    if (_chargeServerHostReplaced) {
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Your order was successful",
          description:
          "Go to your Square dashbord to see this order reflected in the sales tab.");
    }
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    if (!_chargeServerHostReplaced) {
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
      _showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result);
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    } on ChargeException catch (ex) {
      InAppPayments.showCardNonceProcessingError(ex.errorMessage);
    }
  }

  Future<void> _onStartCardEntryFlow(price,uid) async {
    await InAppPayments.setSquareApplicationId("sq0idp-XVbcSkfmHHhgOwhwYc5LAw");
    await InAppPayments.startCardEntryFlow(
       // onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardNonceRequestSuccess:(CardDetails result){
          backend(result, price, uid);
          try{
            debugPrint("on start loop");
            debugPrint("$price");
            debugPrint("$uid");
            InAppPayments.completeCardEntry(onCardEntryComplete: ()=>{});
          }on ChargeException catch (ex){
            debugPrint("error");
            debugPrint("$price");
            debugPrint("$uid");
            InAppPayments.showCardNonceProcessingError(ex.errorMessage);
          }
        },
        onCardEntryCancel: _onCancelCardEntryFlow,
        collectPostalCode: true);
  }
  // ignore: type_annotate_public_apis
  Future<void> backend(CardDetails result,price,uid) async{

    var chargeURL = "https://us-central1-square-877d2.cloudfunctions.net/squarePayments";
    var body = json.encode({"nonce": result.nonce, "price": price, "uid": uid
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
    }catch (error) {
      // ignore: avoid_catches_without_on_clauses
      print(error.toString());
    }
    var responseBody = jsonDecode(response.body);
    if(response.statusCode ==200){
    print("Success");
    await Prov.of(context)
        .db
        .collection('shippingDetails')
        .document(DateTime.now().toString())
        .setData(user.toJson());

//
//      print("response.body");
//      print(response.body);
//      print("response.request");
//      print(response.request);
//
//      print("responseBody");
      print(responseBody);
//      print("responseBody.toString");
//      print(responseBody.toString());
//      print("Price");
//      print(price);
//      print("UID");
//      print(uid);
//
//    print(responseBody.toString());
      return;
    }else{
      print("Error");
    }
  }




  Future<void> _onStartCardEntryFlowWithBuyerVerification(price,uid) async {
    var money = Money((b) => b
      ..amount = 100
      ..currencyCode = 'USD');

    var contact = Contact((b) => b
      ..givenName = "John"
      ..familyName = "Doe"
      ..addressLines =
       BuiltList<String>(["London Eye", "Riverside Walk"]).toBuilder()
      ..city = "London"
      ..countryCode = "GB"
      ..email = "johndoe@example.com"
      ..phone = "8001234567"
      ..postalCode = "SE1 7");

    await InAppPayments.setSquareApplicationId("sq0idp-XVbcSkfmHHhgOwhwYc5LAw");
    await InAppPayments.startCardEntryFlowWithBuyerVerification(
        onCardEntryCancel: _onCancelCardEntryFlow,
        //onBuyerVerificationSuccess: _onBuyerVerificationSuccess,

        onBuyerVerificationSuccess: (BuyerVerificationDetails result){

          verifyBackend(result, price, uid);
          try{
            debugPrint("on start loop");
            debugPrint("$price");
            debugPrint("$uid");
            InAppPayments.completeCardEntry(onCardEntryComplete: ()=>{});
          }on ChargeException catch (ex){
            debugPrint("error");
            debugPrint("$price");
            debugPrint("$uid");
            InAppPayments.showCardNonceProcessingError(ex.errorMessage);
          }
        },
        onBuyerVerificationFailure: _onBuyerVerificationFailure,

        buyerAction: "Charge",
        money: money,
        squareLocationId: "sq0idp-XVbcSkfmHHhgOwhwYc5LAw",
        contact: contact,
        collectPostalCode: true);
        debugPrint("PASS");
  }

  Future<void> verifyBackend(BuyerVerificationDetails result,price,uid) async{

    var chargeURL = "https://us-central1-square-877d2.cloudfunctions.net/squarePayments";
    var body = json.encode({ "nonce": result.nonce, "price": price, "address": uid
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
    }catch (error) {
      // ignore: avoid_catches_without_on_clauses
      print(error.toString());
    }
    var responseBody = jsonDecode(response.body);
    if(response.statusCode ==200){
    print("Success");

      print("response.body");
      print(response.body);
      print("response.request");
      print(response.request);

      print("responseBody");
      print(responseBody);
      print("responseBody.toString");
      print(responseBody.toString());
      print("Price");
      print(price);
      print("Address");
      print(uid);
//
//    print(responseBody.toString());
      return;
    }else{
      print("Error");
    }
  }

  void _onCancelCardEntryFlow() {
    _showOrderSheet();
  }

  void _onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
          priceStatus: google_pay_constants.totalPriceStatusFinal,
          price: getCookieAmount(),
          currencyCode: 'USD',
          onGooglePayNonceRequestSuccess: _onGooglePayNonceRequestSuccess,
          onGooglePayNonceRequestFailure: _onGooglePayNonceRequestFailure,
          onGooglePayCanceled: onGooglePayEntryCanceled);
    } on PlatformException catch (ex) {
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Failed to start GooglePay",
          description: ex.toString());
    }
  }

  void _onGooglePayNonceRequestSuccess(CardDetails result) async {
    if (!_chargeServerHostReplaced) {
      _showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result);
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Your order was successful",
          description:
          "Go to your Square dashbord to see this order reflected in the sales tab.");
    } on ChargeException catch (ex) {
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Error processing GooglePay payment",
          description: ex.errorMessage);
    }
  }

  void _onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    showAlertDialog(
        context: BuySheet.scaffoldKey.currentContext,
        title: "Failed to request GooglePay nonce",
        description: errorInfo.toString());
  }

  void onGooglePayEntryCanceled() {
    _showOrderSheet();
  }

  void _onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
          price: getCookieAmount(),
          summaryLabel: 'Cookie',
          countryCode: 'US',
          currencyCode: 'USD',
          paymentType: ApplePayPaymentType.finalPayment,
          onApplePayNonceRequestSuccess: _onApplePayNonceRequestSuccess,
          onApplePayNonceRequestFailure: _onApplePayNonceRequestFailure,
          onApplePayComplete: _onApplePayEntryComplete);
    } on PlatformException catch (ex) {
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Failed to start ApplePay",
          description: ex.toString());
    }
  }

  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    if (!_chargeServerHostReplaced) {
      await InAppPayments.completeApplePayAuthorization(isSuccess: false);
      _showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result);
      _applePayStatus = ApplePayStatus.success;
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Your order was successful",
          description:
          "Go to your Square dashbord to see this order reflected in the sales tab.");
      await InAppPayments.completeApplePayAuthorization(isSuccess: true);
    } on ChargeException catch (ex) {
      await InAppPayments.completeApplePayAuthorization(
          isSuccess: false, errorMessage: ex.errorMessage);
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Error processing ApplePay payment",
          description: ex.errorMessage);
      _applePayStatus = ApplePayStatus.fail;
    }
  }

  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    _applePayStatus = ApplePayStatus.fail;
    await InAppPayments.completeApplePayAuthorization(
        isSuccess: false, errorMessage: errorInfo.message);
    showAlertDialog(
        context: BuySheet.scaffoldKey.currentContext,
        title: "Error request ApplePay nonce",
        description: errorInfo.toString());
  }

  void _onApplePayEntryComplete() {
    if (_applePayStatus == ApplePayStatus.unknown) {
      // the apple pay is canceled
      _showOrderSheet();
    }
  }

  void _onBuyerVerificationSuccess(BuyerVerificationDetails result) async {
    if (!_chargeServerHostReplaced) {
      debugPrint("verification:");
      debugPrint(result.toString());
      _showUrlNotSetAndPrintCurlCommand(result.nonce,
          verificationToken: result.token);
      return;
    }

    try {
      await chargeCardAfterBuyerVerification(result);
    } on ChargeException catch (ex) {
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Error processing card payment",
          description: ex.errorMessage);
    }
  }

  void _onBuyerVerificationFailure(ErrorInfo errorInfo) async {
    showAlertDialog(
        context: BuySheet.scaffoldKey.currentContext,
        title: "Error verifying buyer",
        description: errorInfo.toString());
  }

  Widget build(BuildContext context) => MaterialApp(

    theme: ThemeData(canvasColor: Colors.transparent),
    home: Scaffold(
      appBar: AppBar(
        title: Text("Purchase Art for Your Home"),
        backgroundColor: Colors.blueGrey,
        leading:
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>

          Navigator.of(context, rootNavigator: true).pop(context),

//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) =>
//                  //    DefaultDisplayScreen(geode: geodesList[index].image)));
//                  Feed())),
        )
      ),
      backgroundColor: mainBackgroundColor,
      key: BuySheet.scaffoldKey,
      body: Builder(
        builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
//                  child: Image(image: AssetImage(
//                      "assets/iconCookie.png"
//                      )),
                child: imageOrientation(context),
                ),
                Container(
//                  child: Text(
//                    'Super Cookie',
//                    style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 28,
//                    ),
//                  ),
                  child: textBuild(context),
                ),
                Container(
                  child: Text(
                    "Instantly gain special powers \nwhen ordering a super cookie",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  //margin: EdgeInsets.only(top: 32),
                // child: CookieButton(text: "Buy", onPressed: _showOrderSheet),
                  child: CookieButton(text: "Buy",
                    onPressed: () {
                      _userEditBottomSheet(context);
                    },
                      ),

//                    child: CookieButton(text: "Buy", onPressed:(){
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => AddressScreen()));
//                    }
//                    ),
                   // AddressScreen
                ),
              ],
            )),
      ),
    ),
  );

  // ignore: type_annotate_public_apis
  imageOrientation(BuildContext context) {
    var foodNotifier = Provider.of<FoodNotifier>(context);
    if (MediaQuery
        .of(context)
        .orientation == Orientation.portrait) {
      return
        Image.network(
          foodNotifier.currentFood.image != null
              ? foodNotifier.currentFood.image
              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: 250,
          fit: BoxFit.fitWidth,
        );
    } else if (MediaQuery
        .of(context)
        .orientation == Orientation.landscape) {
      return
        Image.network(
          foodNotifier.currentFood.image != null
              ? foodNotifier.currentFood.image
              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: ((MediaQuery
              .of(context)
              .size
              .height) / 4),
          fit: BoxFit.fitHeight,
        );
    }
  }

  textBuild(BuildContext context){
    var foodNotifier = Provider.of<FoodNotifier>(context);
    return Padding(
      padding: const EdgeInsets.only(top:50.0),
      child: Text("Price: ${foodNotifier.currentFood.price}",style: TextStyle(color: Colors.blueGrey ,fontStyle: FontStyle.italic), textScaleFactor: 1.8,),
    );
  }

  void _userEditBottomSheet(BuildContext context) {
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
                        user.uid = await Prov.of(context).auth.getCurrentUID();
                        user.painting = await Provider.of<FoodNotifier>(context, listen: false).currentFood.title;
                        user.price = await Provider.of<FoodNotifier>(context, listen: false).currentFood.price;
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
                       // Navigator.of(context).pop();
                        _showOrderSheet();
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

class User {
  String userName;
  String streetAddress;
  String homeCity;
  String homePostalCode;
  String homeCountry;
  bool admin;
  String uid;
  String painting;
  String price;

  User(this.userName,this.streetAddress, this.homeCity, this.homePostalCode, this.homeCountry );

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'streetAddress': streetAddress,
    'homeCity': homeCity,
    'homePostalCode': homePostalCode,
    'homeCountry': homeCountry,
    'admin': admin,
    'uid': uid,
    'painting': painting,
    'price': price,
  };
}







