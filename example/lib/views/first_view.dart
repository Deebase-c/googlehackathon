import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:square_in_app_payments_example/widgets/custom_dialog.dart';


class FirstView extends StatelessWidget {
  final primaryColor = const Color(0xFF75A2EA);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Builder(
        builder: (context) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height:  MediaQuery.of(context).size.height,
              child: Image.asset(
                  'assets/gallery.jpg'
                  ,fit: BoxFit.cover,
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  colorBlendMode: BlendMode.modulate
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(height: _height * 0.10),
                Text(
                  "Welcome",
                  style: TextStyle(fontSize: 44, color: Colors.white),
                ),
                SizedBox(height: _height * 0.10),
                AutoSizeText(
                  "Interior Art Design App",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: _height * 0.15),
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                        title: "Would you like to create a free account?",
                        description:
                        "With an account, your data will be securely saved, allowing you to access it from multiple devices.",
                        primaryButtonText: "Create My Account",
                        primaryButtonRoute: "/signUp",
                        secondaryButtonText: "Maybe Later",
                        secondaryButtonRoute: "/anonymousSignIn",
                      ),
                    );
                  },
                ),
                SizedBox(height: _height * 0.05),
                FlatButton(
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/signIn');
                  },
                )
              ],
            ),
          ],
        ),),
    );
  }
}
