
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:square_in_app_payments_example/views/default_selection/interior_selection.dart';
import 'package:square_in_app_payments_example/views/user_upload_image/user_upload_interior_image.dart';



class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}


class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.blueGrey,
//        title: Text("Pick a Room Layout"),
//      ),
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
              child: Image.network(
                  'https://static.wixstatic.com/media/c2695d_20635205491f46d1a51a599778f0c8ff~mv2.jpg/v1/fill/w_404,h_538,al_c,lg_1,q_80/c2695d_20635205491f46d1a51a599778f0c8ff~mv2.webp',
                  fit: BoxFit.cover,
                  color: Color.fromRGBO(255, 255, 255, 0.3),
                  colorBlendMode: BlendMode.modulate),

            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: CameraSnackBarPage(),

                ),
                Expanded(
                  child: FolderSnackBarPage(),

                ),
              ],
            ),
          ],
        ),
      ),
    );
}

class CameraSnackBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: RawMaterialButton(
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white70,
                child: Icon(
                  FontAwesomeIcons.cameraRetro,
                  color: Colors.blueGrey,
                  size: 70.0,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(),
                      ));

//          final snackBar = SnackBar (
//            content: Text('Take an Interior Photo'),
//           action:
//              SnackBarAction(
//                  label: 'Undo',
//              onPressed: (){
//                _CameraScreenState();
//             //   ImageCapture();
//              }
//          ),
//          );
//          Scaffold.of(context).showSnackBar(snackBar);
                }),

          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(" Upload Background\n  Image from Phone", style: TextStyle(color: Colors.blueGrey[700], fontSize: 18 ),),
          ),
        ],
      ),
    );
}
//
//class FileSnackBarPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Center(
//      child: RawMaterialButton(
//          shape: CircleBorder(),
//          elevation: 2.0,
//          fillColor: Colors.white70,
//          child: Icon(
//            FontAwesomeIcons.fileUpload,
//            color: Colors.blueGrey,
//            size: 70.0,
//          ),
//          onPressed: () {
//            final snackBar = SnackBar (
//              content: Text('Upload an Image from your Phone'),
//              action:
//              SnackBarAction(
//                  label: 'Undo',
//                  onPressed: (){
//
//                  }
//              ),
//            );
//            Scaffold.of(context).showSnackBar(snackBar);
//          }
//      ),
//    );
//  }
//}

class FolderSnackBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: MaterialButton(

              shape: CircleBorder(),
              elevation: 2.0,
              //fillColor: Colors.white70,
              child: Icon(
                FontAwesomeIcons.folderOpen,
                color: Colors.blueGrey,
                size: 70.0,

              ),

              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => InteriorScrollView()));
              },
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("Select Background\nfrom Stock Photos", style: TextStyle(color: Colors.blueGrey[700], fontSize: 18 ),),
          ),
        ],
      ),
    );
}
