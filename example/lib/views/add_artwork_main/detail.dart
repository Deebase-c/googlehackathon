
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments_example/models/art.dart';
import 'package:square_in_app_payments_example/services/art_notifier.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/art_form.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/artwork_api.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/pay_home_screen.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/payment_option.dart';
import 'package:square_in_app_payments_example/widgets/buy_sheet.dart';
import 'package:square_in_app_payments_example/widgets/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:square_in_app_payments_example/views/user_upload_image/art_selected_to_purchase.dart';
import '../../widgets/provider_widget.dart';


class FoodDetail extends StatefulWidget {


  @override
  _FoodDetailState createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  User user = User("");
  bool _isAdmin = false;

  @override
  Widget build(BuildContext context) {
    var foodNotifier = Provider.of<FoodNotifier>(context);

//    _onFoodDeleted(Food food) {
//      Navigator.pop(context);
//      foodNotifier.deleteFood(food);
//    }

    return Scaffold(
      appBar: AppBar(
        title: Text(foodNotifier.currentFood.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(
                  title: "Purchase artwork in the comfort of your own home!",
                  description:
                  "1. Select the Artwork of your choice. \n2. Click the Shopping cart button on the bottom right hand side of the screen.",
                  primaryButtonText: "Got It.",
                  primaryButtonRoute: "/gotIt",
                  //secondaryButtonText: "Maybe Later",
                  //secondaryButtonRoute: "/anonymousSignIn",
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.network(
                  foodNotifier.currentFood.image != null
                      ? foodNotifier.currentFood.image
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 20),

                Text(
                  foodNotifier.currentFood.artist,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Title: ${foodNotifier.currentFood.title}',
                  style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20),
                Text(
                  'Size: ${foodNotifier.currentFood.size}',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
                ),
                //SizedBox(height: 20),
                Text(
                  'Description: ${foodNotifier.currentFood.description}',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
                ),
                SizedBox(height: 20),
                Text(
                  'Price: ${foodNotifier.currentFood.price} ',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20),
                Text(
                  "Medium(s) Used:",
                  style: TextStyle(fontSize: 18, decoration: TextDecoration.underline),
                ),

                SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(8),
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: foodNotifier.currentFood.medium
                      .map(
                        (ingredient) => Card(
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          ingredient,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        //crossAxisAlignment: CrossAxisAlignment.baseline,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

//          FloatingActionButton(
//            heroTag: 'button1',
//            onPressed: () {
//
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => PaymentOption()));
//              //foodNotifier.currentFood = foodNotifier.foodList[index];
//
//
//            },
//            child: Icon(Icons.shopping_cart),
//            foregroundColor: Colors.white,
//            backgroundColor: Colors.blueGrey,
//          ),
          ////        SizedBox(height: 20),
//          FloatingActionButton(
//            heroTag: 'button2',
//            onPressed: () {
//              Navigator.of(context).push(
//                MaterialPageRoute(builder: (BuildContext context) {
//                  return FoodForm(
//                    isUpdating: true,
//                  );
//                }),
//              );
//            },
//            child: Icon(Icons.edit),
//            foregroundColor: Colors.white,
//          ),
          // SizedBox(height: 20),
          FutureBuilder(
              future: _getProfileData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
//                _userCountryController.text = user.homeCountry;
                  _isAdmin = user.admin ?? false;
                }
                return Container(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      adminShopping(),
                      SizedBox(height: 20),
                      adminDelete(),
                      SizedBox(height: 20),
                      adminEdit(),
                    ],
                  ),
                );
              }
          ),
//          FloatingActionButton(
//            heroTag: 'button3',
//            onPressed: () => deleteFood(foodNotifier.currentFood, _onFoodDeleted),
//            child: Icon(Icons.delete),
//            backgroundColor: Colors.red,
//            foregroundColor: Colors.white,
//          ),
        ],
      ),
    );
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
  Widget adminDelete() {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);
    _onFoodDeleted(Food food) {
      Navigator.pop(context);
      foodNotifier.deleteFood(food);
    }
    if(_isAdmin == true) {
      return
        Container(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            heroTag: 'button3',
            onPressed: () => deleteFood(foodNotifier.currentFood, _onFoodDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        );
    } else {
      return Container(alignment: Alignment.bottomRight,);
    }
  }
  Widget adminEdit() {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    if(_isAdmin == true) {
      return
        Container(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            heroTag: 'button2',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return FoodForm(
                    isUpdating: true,
                  );
                }),
              );
            },
            child: Icon(Icons.edit),
            foregroundColor: Colors.white,
          ),
        );
    } else {
      return Container(alignment: Alignment.bottomRight,);
    }
  }
  Widget adminShopping() {
    var foodNotifier = Provider.of<FoodNotifier>(context);

    if(_isAdmin == true) {
      return Container(alignment: Alignment.bottomRight,);
//        FloatingActionButton(
//          heroTag: 'button1',
//          onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PayHomeScreen()));
//          },
//          child: Icon(Icons.shopping_cart),
//          foregroundColor: Colors.white,
//          backgroundColor: Colors.blueGrey,
//        );
    } else {
      return  Container(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          heroTag: 'button1',
          onPressed: () {
           //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ArtSelected()));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PayHomeScreen()));



          },
          child: Icon(Icons.shopping_cart),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueGrey,
        ),
      );
    }
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

