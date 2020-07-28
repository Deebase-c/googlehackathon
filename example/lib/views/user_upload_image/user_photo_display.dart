import 'dart:async';
//import 'dart:io';
import 'dart:math';
//import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:flutter/services.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:square_in_app_payments_example/views/user_upload_image/quote_form.dart';
import 'package:square_in_app_payments_example/widgets/custom_dialog.dart';
import 'package:permission_handler/permission_handler.dart';





class UserPhotoDisplayScreen extends StatefulWidget {
  final String geode;
  final String title;

  UserPhotoDisplayScreen({Key key, this.geode, this.title}) : super(key: key);

  @override
  _UserPhotoDisplayScreenState createState() => _UserPhotoDisplayScreenState();
}

const double min = pi * -2;
const double max = pi * 2;
const double minScale = 0.01;
const double defScale = 0.2;
const double maxScale = 0.5;

class _UserPhotoDisplayScreenState extends State<UserPhotoDisplayScreen> {
  String status;
  Permission permission;

  String _downloadURL;
  final StorageReference _reference = FirebaseStorage.instance.ref().child("myimage.jpg");
  // String _background ;

  double scale = 0.0;
  static GlobalKey previewContainer = GlobalKey();
  // int _counter = 0;

//  void _incrementCounter() {
//    setState(() {
//      // This call to setState tells the Flutter framework that something has
//      // changed in this State, which causes it to rerun the build method below
//      // so that the display can reflect the updated values. If we changed
//      // _counter without calling setState(), then the build method would not be
//      // called again, and so nothing would appear to happen.
//      _counter++;
//    });
//  }


  PhotoViewControllerBase controller;
  PhotoViewScaleStateController scaleStateController;

  int calls = 0;
  bool pressed = false;

// double size = defScale;
  // double finalScale = sizeFinal;

  @override
  void initState() {
    // getStringValuesRead();
    controller = PhotoViewController()
      ..scale = defScale
      ..outputStateStream.listen(onController);

    scaleStateController = PhotoViewScaleStateController()
      ..outputScaleStateStream.listen(onScaleState);

    scaleStateController.scaleState = PhotoViewScaleState.initial;
    // imageCache.clear();
    downloadImage();
    requestPermission();

    super.initState();

//    getStringValuesRead().then((value) {
//      print("value: $value");
//      _background = value;
//      setState(() {});
//    });

    _showDialog();


  }

  _showDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Adjust Artwork",
        description:
        "1. Adjust the POSITIONING: \n Press and hold on the artwork, drag and drop it where desired. \n 2. Adjust the SIZE: \n With two fingers pinch to re-scale \n 3. Adjust the ROTATION: \n Long-press with two fingers then pivot the artwork to the desired angle ",
        primaryButtonText: "Got It.",
        primaryButtonRoute: "/gotIt",
        //secondaryButtonText: "Maybe Later",
        //secondaryButtonRoute: "/anonymousSignIn",
      ),
    );
  }

  void requestPermission() async{
    var res = await Permission.storage.request();
  }

  void onController(PhotoViewControllerValue value) {
    setState(() {
      calls += 1;
    });
  }

  void onScaleState(PhotoViewScaleState scaleState) {
    print(scaleState);
  }

  void goBack() {
    scaleStateController = PhotoViewScaleStateController()
      ..outputScaleStateStream.listen(onScaleState);

    scaleStateController.scaleState = PhotoViewScaleState.initial;
  }

  @override
  void dispose() {
    controller.dispose();
    scaleStateController.dispose();
    super.dispose();
  }

//  void goBack() {
//    scaleStateController.scaleState = PhotoViewScaleState.originalSize;
//  }

  Future  downloadImage() async{
    String downloadAddress = await _reference.getDownloadURL();
    setState(() {
      _downloadURL = downloadAddress;
      debugPrint("$_downloadURL");
    });
  }

  @override
  Widget build(BuildContext context) {

    // ignore: omit_local_variable_types
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    //  var realHeight = MediaQuery.of(context).size.height;
    if (_downloadURL == null){
      return CircularProgressIndicator();
      // return Container();
    }
    else {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("Adjust Artwork"),
            backgroundColor: Colors.blueGrey,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.help,
                  color: Colors.white,
                ),
                onPressed: _showDialog,
              )
            ],
          ),

          body: RepaintBoundary(
            key: previewContainer,
            child:
//          new FutureBuilder(
//              //future: getStringValuesRead(),
//            future: downloadImage(),
//              initialData: "Waiting...",
//              builder: (BuildContext context, AsyncSnapshot snapshot){
//                print('snapshot: $snapshot');
            //////////////////////////////
            //return
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    // image: AssetImage(snapshot.data),
                      image: NetworkImage(
                          _downloadURL
                      ),
                      fit: BoxFit.cover)
              ),

              child: MatrixGestureDetector(
                onMatrixUpdate: (m, tm, sm, rm) {
                  notifier.value = m;
                },
                child: AnimatedBuilder(
                  animation: notifier,
                  builder: (ctx, child) => Transform(
                      transform: notifier.value,
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(top: 50),
                              child: Transform.scale(
                                scale: 1,
                                // make this dynamic to change the scaling as in the basic demo
                                origin: Offset(0.0, 0.0),
                                child: Container(
                                  height: 100,
                                  child:
                                  //  imageAssetGeode()
                                  // Image.asset(widget.geode),
                                  Image.network(widget.geode),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ),
              ),
            ),
            ////////////////////////////////////////////////////////////////////////////
            // }),
          ),

//        floatingActionButton: FloatingActionButton(
//            backgroundColor: Colors.blueGrey,
//            child: Icon(FontAwesomeIcons.plus, color: Colors.white),
//            onPressed: () {
//            screenShot();
//
//
////              Navigator.push(
////                  context,
////                  new MaterialPageRoute(
////                    builder: (context) => ArtScrollView(),
////                  ));
//            }
//
//            ),

          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            onPressed: () {
//              requestPermission();
//            debugPrint('$_counter');
//            _incrementCounter();
//            setState(() {
//              if (pressed == false) {
//
//              } else if (pressed == true) {
//                pressed = false;
//              }
//            });
//            setState(() {
//              //               initState();
//              goBack();
//            });

              Timer(Duration(seconds: 1), () {
                _saveScreen();
                debugPrint("Yeah, this line is printed after 1 seconds");
              }
              );

              _showAlert();
            },
            //screenShot,
            tooltip: 'Increment',
            child: Icon(FontAwesomeIcons.save, color: Colors.white),
          ),

        ),
      );
    }
  }


  void _showAlert() {
      var dialog = AlertDialog(
        content: Text(
          "Image Saved to Phone Gallery!",
//            " \nWould You Like a Quote?",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 30,
              fontStyle: FontStyle.italic),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => EnterQuoteSelectionsScreen()));
              }),
//        FlatButton(
//            child: Text("No"),
//            onPressed: () {
//              Navigator.pop(context);
////            onPressed: (){
////              Navigator.push(
////                  context,
////                  MaterialPageRoute(
////                      builder: (context) => SendEmail()));
//            }),
        ],
      );
      showDialog(context: context, child: dialog);
    }


  _saveScreen() async {
    RenderRepaintBoundary boundary = previewContainer.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
   // final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
   // print(result);
  }

  containerNewGeode(BuildContext context) {
    if (MediaQuery
        .of(context)
        .orientation == Orientation.portrait) {
      return portraitGeode();
    } else {
      return landscapeGeode();
    }
  }
  // ignore: type_annotate_public_apis
  containerOnlyBackground(BuildContext context) {
    if (MediaQuery
        .of(context)
        .orientation == Orientation.portrait) {
      return landscapeAndPortraitBackground();
    } else {
      return landscapeAndPortraitBackground();
    }
  }
  // ignore: type_annotate_public_apis
  geodeOrientation(BuildContext context) {
    if (MediaQuery
        .of(context)
        .orientation == Orientation.portrait) {
      return EdgeInsets.only(
        //right: 10, left: 10, bottom: 10, top: 10),
          right: 110,
          left: 110,
          bottom: 270,
          top: 170);
    } else {
      return EdgeInsets.only(right: 60, left: 60, bottom: 130, top: 30);
    }
  }
  // ignore: type_annotate_public_apis
  portraitGeode() => Container(
      margin: EdgeInsets.only(
        //right: 10, left: 10, bottom: 10, top: 10),
          right: 110,
          left: 110,
          bottom: 270,
          top: 170),
      //     child: Image.asset(((geode) == null) ? "images/teal geode.jpg" : geode),
      child: imageAssetGeode(),
    );
  // ignore: type_annotate_public_apis
  landscapeGeode() => Container(
      margin: EdgeInsets.only(right: 50, left: 50, bottom: 110, top: 30),
      //  child: imageAsset(context),
      child: imageAssetGeode(),
    );
  // ignore: type_annotate_public_apis
  landscapeAndPortraitBackground() => Container(
      // child: imageAssetBackground(),
    );

  // ignore: type_annotate_public_apis
  imageAssetGeode() {
    if ((widget.geode) == null) {
      return Image.asset("images/geode teal.jpg");
    } else if ((widget.geode) != null) {
      return Image.asset(widget.geode);
    }
  }
} //added

/// Permission widget which displays a permission and allows users to request
/// the permissions.
class PermissionWidget extends StatefulWidget {
  /// Constructs a [PermissionWidget] for the supplied [Permission].
  const PermissionWidget(this._permission);

  final Permission _permission;

  @override
  _PermissionState createState() => _PermissionState(_permission);
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState(this._permission);

  final Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

  @override
  void initState() {
    super.initState();
    requestPermission(_permission);
    _listenForPermissionStatus();

  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) => ListTile(
      title: Text(_permission.toString()),
      subtitle: Text(
        _permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      trailing: IconButton(
          icon: const Icon(Icons.info),
          onPressed: () {
            checkServiceStatus(context, _permission);
          }),
      onTap: () {
        requestPermission(_permission);
      },
    );

  void checkServiceStatus(BuildContext context, Permission permission) async {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text((await permission.status).toString()),
    ));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await Permission.storage.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }
}

