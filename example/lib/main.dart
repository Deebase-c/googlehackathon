///*
// Copyright 2018 Square Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//*/
//import 'dart:async';
//import 'dart:io' show Platform;
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:square_in_app_payments/models.dart';
//import 'package:square_in_app_payments/in_app_payments.dart';
//import 'package:square_in_app_payments/google_pay_constants.dart'
//    as google_pay_constants;
//import 'colors.dart';
//import 'config.dart';
//import 'widgets/buy_sheet.dart';
//
//void main() => runApp(MaterialApp(
//      title: 'Super Cookie',
//      home: PayHomeScreen(),
//    ));
//
//class PayHomeScreen extends StatefulWidget {
//  PayHomeScreenState createState() => PayHomeScreenState();
//}
//
//class PayHomeScreenState extends State<PayHomeScreen> {
//  bool isLoading = true;
//  bool applePayEnabled = false;
//  bool googlePayEnabled = false;
//
//  static final GlobalKey<ScaffoldState> scaffoldKey =
//      GlobalKey<ScaffoldState>();
//
//  @override
//  void initState() {
//    super.initState();
//    _initSquarePayment();
//
//    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//  }
//
//  Future<void> _initSquarePayment() async {
//    await InAppPayments.setSquareApplicationId(squareApplicationId);
//
//    var canUseApplePay = false;
//    var canUseGooglePay = false;
//    if (Platform.isAndroid) {
//      await InAppPayments.initializeGooglePay(
//          squareLocationId, google_pay_constants.environmentTest);
//      canUseGooglePay = await InAppPayments.canUseGooglePay;
//    } else if (Platform.isIOS) {
//      await _setIOSCardEntryTheme();
//      await InAppPayments.initializeApplePay(applePayMerchantId);
//      canUseApplePay = await InAppPayments.canUseApplePay;
//    }
//
//    setState(() {
//      isLoading = false;
//      applePayEnabled = canUseApplePay;
//      googlePayEnabled = canUseGooglePay;
//    });
//  }
//
//  Future _setIOSCardEntryTheme() async {
//    var themeConfiguationBuilder = IOSThemeBuilder();
//    themeConfiguationBuilder.saveButtonTitle = 'Pay';
//    themeConfiguationBuilder.errorColor = RGBAColorBuilder()
//      ..r = 255
//      ..g = 0
//      ..b = 0;
//    themeConfiguationBuilder.tintColor = RGBAColorBuilder()
//      ..r = 36
//      ..g = 152
//      ..b = 141;
//    themeConfiguationBuilder.keyboardAppearance = KeyboardAppearance.light;
//    themeConfiguationBuilder.messageColor = RGBAColorBuilder()
//      ..r = 114
//      ..g = 114
//      ..b = 114;
//
//    await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
//  }
//
//  Widget build(BuildContext context) => MaterialApp(
//      theme: ThemeData(canvasColor: Colors.white),
//      home: Scaffold(
//          body: isLoading
//              ? Center(
//                  child: CircularProgressIndicator(
//                  valueColor:
//                      AlwaysStoppedAnimation<Color>(mainBackgroundColor),
//                ))
//              : BuySheet(
//                  applePayEnabled: applePayEnabled,
//                  googlePayEnabled: googlePayEnabled,
//                  applePayMerchantId: applePayMerchantId,
//                  squareLocationId: squareLocationId)));
//}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments_example/services/art_notifier.dart';
import 'package:square_in_app_payments_example/services/auth_notifier.dart';
import 'package:square_in_app_payments_example/services/auth_service.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/pay_home_screen.dart';
import 'package:square_in_app_payments_example/views/feed.dart';
import 'package:square_in_app_payments_example/views/first_view.dart';
import 'package:square_in_app_payments_example/views/navigation_view.dart';
import 'package:square_in_app_payments_example/views/sign_up_view.dart';
import 'package:square_in_app_payments_example/widgets/buy_sheet.dart';
import 'package:square_in_app_payments_example/widgets/provider_widget.dart';
//import 'package:travel_budget/views/AddArtworkMain/ExistingCards.dart';
//import 'package:travel_budget/views/AddArtworkMain/art_notifier.dart';


//import 'package:firebase_admob/firebase_admob.dart';
//import 'package:travel_budget/services/admob_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //FirebaseAdMob.instance.initialize(appId: AdMobService().getAdMobAppId());
  // runApp(MyApp());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => FoodNotifier(),
      ),
    ],
    child: MyApp(),
  ));

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Prov(
        auth: AuthService(),
        db: Firestore.instance,
        child:
        MaterialApp(
          // title: "Travel Budget App",

          theme: ThemeData(
              primarySwatch: Colors.blueGrey,

              textTheme: TextTheme(
                //  body1: GoogleFonts.bitter(fontSize: 14.0)
              )
          ),
          home: HomeController(),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => HomeController(),
            '/signUp': (BuildContext context) => SignUpView(authFormType: AuthFormType.signUp),
            '/signIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.signIn),
            '/anonymousSignIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.anonymous),
            '/convertUser': (BuildContext context) => SignUpView(authFormType: AuthFormType.convert),
            '/feed': (BuildContext context) => Feed(),
            // '/ExistingCards': (BuildContext context) => ExistingCards(),
        //  '/gotIt':  Navigator.of(context, rootNavigator: true).pop(),
          },
        ),
      );
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: omit_local_variable_types
    final AuthService auth = Prov.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // ignore: omit_local_variable_types
          final bool signedIn = snapshot.hasData;
          return signedIn ? Home() : FirstView();
          //return signedIn ? Home() : PayHomeScreen();

        }
        return CircularProgressIndicator();
      },
    );
  }
}