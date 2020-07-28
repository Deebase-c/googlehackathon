
import 'package:square_in_app_payments_example/services/art_notifier.dart';
import 'package:square_in_app_payments_example/services/auth_notifier.dart';
import 'package:square_in_app_payments_example/views/add_artwork_main/artwork_api.dart';
import 'package:square_in_app_payments_example/views/user_upload_image/user_photo_display.dart';
import 'package:square_in_app_payments_example/widgets/provider_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedSelectionUser extends StatefulWidget {
  @override
  _FeedSelectionUserState createState() => _FeedSelectionUserState();
}

class _FeedSelectionUserState extends State<FeedSelectionUser> {
  @override
  void initState() {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context, listen: false);
    getFoods(foodNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    Future<void> _refreshList() async {
      getFoods(foodNotifier);
    }

    print("building Feed");
    return Scaffold(
      appBar: AppBar(

        title: Text(
          // authNotifier.user != null ? authNotifier.user.displayName : "Feed",
          //  _buildArtistField();
          "Artwork Selection",
        ),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.exit_to_app),
//            onPressed: () {
//
//            },
//          ),
        ],
      ),
      body: RefreshIndicator(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: ListTile(
                    title: Column(
                      children: <Widget>[
                        // Image.network(record.url),
                        Image.network(
                          foodNotifier.foodList[index].image != null
                              ? foodNotifier.foodList[index].image
                              : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
//                              Text(
////                        "Title: {$foodNotifier.foodList[index].title} \n Artist: Ashley Mooney \n Medium: Resin \n Size: 20x16 ",
////                        //   "",
//                                "${foodNotifier.foodList[index].artist}\n${foodNotifier.foodList[index].title}" ,
//                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
//
//                              ),
                              Text(
                                "${foodNotifier.foodList[index].artist}",
                                style: TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                              Text(
                                'Title: ${foodNotifier.foodList[index].title}',
                                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                              ),
                              Text(
                                'Description: ${foodNotifier.foodList[index].description}',
                                style: TextStyle(fontSize: 12, fontStyle: FontStyle.normal),
                              ),
//                              Text(
//                                'Title: ${foodNotifier.currentFood.title}',
//                                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
//                              ),
                              // Text("test"),
                            ],
                          ),



                        ),
                      ],
                    ),
                    onTap: () {
//                      foodNotifier.currentFood = foodNotifier.foodList[index];
//                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
//                        return FoodDetail();
//                      }));
                      foodNotifier.currentFood = foodNotifier.foodList[index];
                      debugPrint("image");
                      debugPrint(foodNotifier.foodList[index].image);
                      Navigator.push(
                          context,MaterialPageRoute(
                          builder: (context) =>
                              UserPhotoDisplayScreen(geode: foodNotifier.foodList[index].image)));
                    },
                  ),
                ),
              ),
          itemCount: foodNotifier.foodList.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.black,
            ),
        ),
        onRefresh: _refreshList,
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          foodNotifier.currentFood = null;
//          Navigator.of(context).push(
//            MaterialPageRoute(builder: (BuildContext context) {
//              return FoodForm(
//                isUpdating: false,
//              );
//            }),
//          );
//        },
//        child: Icon(Icons.add_a_photo),
//        foregroundColor: Colors.white,
//      ),
    );
  }

  Widget _buildArtistField() => FutureBuilder(
      future: Prov.of(context).auth.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return displayUserInformation(context, snapshot);
        } else {
          return CircularProgressIndicator();
        }
      },
    );

  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;

    return
      Text(
        "UID: ${authData.uid ?? 'Anonymous'}",
        style: TextStyle(fontSize: 20),
      );

  }
}