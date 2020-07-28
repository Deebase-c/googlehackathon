import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class Food {
  //String FirebaseAuth.instance;

  String id;
  String artist;
  String title;
  String size;
  String uid;
  // String name;
  String description;
  String price;
  String image;
  List medium = [];
  Timestamp createdAt;
  Timestamp updatedAt;


  Food();

  Food.fromMap(Map<String, dynamic> data) {

    id = data['id'];
    artist = data['artist'];
    title = data['title'];
    size = data['size'];
    uid = data['uid'];
    // name = data['name'];
    description = data['description'];
    price = data["price"];
    image = data['image'];
    medium = data['medium'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() => {
      'id': id,
      'artist': artist,
      'title': title,
      'size': size,
      'uid': uid,
      //  'name': name,
      'description' : description,
      "price": price,
      'image': image,
      'medium': medium,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
}