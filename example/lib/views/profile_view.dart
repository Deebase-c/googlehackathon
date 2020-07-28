import 'package:flutter/material.dart';
import 'package:square_in_app_payments_example/widgets/provider_widget.dart';
import 'package:intl/intl.dart';
//import 'AddArtworkMain/feed.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User user = User("");
  bool _isAdmin = false;
  final TextEditingController _userCountryController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(

    body: Builder(
      builder: (context) => Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0x00f5f5f5), Color(0xfff5f5f5)],
                    //  gradient: LinearGradient(colors: [Colors.blueGrey, Colors.white],
                    begin: Alignment.center,
                    end: Alignment.bottomRight)),
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
                "assets/artist studio.jpg",
                fit: BoxFit.cover,
                color: Color.fromRGBO(255, 255, 255, 0.3),
                colorBlendMode: BlendMode.modulate),

          ),
          FutureBuilder(
            future: Prov.of(context).auth.getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return displayUserInformation(context, snapshot);
              } else {
                return CircularProgressIndicator();
              }
            },
          ),

        ],
      ),

    ),
//        floatingActionButton: FloatingActionButton(
//          onPressed: (){
//            //********************
////            Navigator.push(
////                context,
////                MaterialPageRoute(
////                    builder: (context) =>
////                    //    DefaultDisplayScreen(geode: geodesList[index].image)));
////                    Feed()));
//          },
//          child: Icon(Icons.search),
//        ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Name: ${authData.displayName ?? 'Anonymous'}",
              style: TextStyle(fontSize: 20, color: Colors.blueGrey.shade900),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Email: ${authData.email ?? 'Anonymous'}",
              style: TextStyle(fontSize: 20,color: Colors.blueGrey.shade900),
            ),
          ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(
//                "${authData.uid ?? 'Anonymous'}",
//                style: TextStyle(fontSize: 20, color: Colors.black87),
//              ),
//            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Created: ${DateFormat('MM/dd/yyyy').format(authData.metadata.creationTime)}",
              style: TextStyle(fontSize: 20, color: Colors.blueGrey.shade900),
            ),
          ),
          FutureBuilder(
              future: _getProfileData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  _userCountryController.text = user.homeCountry;
                  _isAdmin = user.admin ?? false;
                }
                return Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        Text(
                          "UID: ${authData.uid ?? 'Anonymous'}",
                          style: TextStyle(fontSize: 20,color: Colors.blueGrey.shade900),
                        ),
                      ),
                      adminFeature(),
                    ],
                  ),
                );
              }
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: showSignOut(context, authData.isAnonymous),
                ),
//extra button
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: RaisedButton(
//                    child: Text("User Gallery"),
//                    onPressed: () {
//                      // _userEditBottomSheet(context);
//                      //**************
////                      Navigator.push(
////                          context,
////                          MaterialPageRoute(
////                              builder: (context) =>
////                              //    DefaultDisplayScreen(geode: geodesList[index].image)));
////                              Feed()));
//                    },
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: RaisedButton(
//                    child: Text("Edit User"),
//                    onPressed: () {
//                      _userEditBottomSheet(context);
//                    },
//                  ),
//                ),
              ],
            ),
          )



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
      user.homeCountry = result.data['homeCountry'];
      user.admin = result.data['admin'];

    });
  }

  Widget showSignOut(context, bool isAnonymous) {
    if (isAnonymous == true) {
      return RaisedButton(
        child: Text("Sign In To Save Your Data"),
        onPressed: () {
          Navigator.of(context).pushNamed('/convertUser');
        },
      );
    } else {
      return RaisedButton(
        child: Text("Sign Out"),
        onPressed: () async {
          try {
            await Prov.of(context).auth.signOut();
          } catch (e) {
            print(e);
          }
        },
      );
    }
  }

  Widget adminFeature() {
    if(_isAdmin == true) {
      return Text("You are an admin");
    } else {
      return Container();
    }
  }

  void _userEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .60,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Update Profile"),
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
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: _userCountryController,
                          decoration: InputDecoration(
                            helperText: "Home Country",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Save'),
                      color: Colors.blueGrey,
                      textColor: Colors.white,
                      onPressed: () async {
                        user.homeCountry = _userCountryController.text;
                        setState(() {
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
                      },
                    )
                  ],
                ),
              ],
            ),

          ),
        );

      },
    );

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
