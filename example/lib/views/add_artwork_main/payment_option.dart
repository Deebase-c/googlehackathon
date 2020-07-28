
import 'package:flutter/material.dart';
//import 'package:mastering_payments/services/StripeServices.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments_example/services/art_notifier.dart';
import 'package:square_in_app_payments_example/widgets/order_sheet.dart';

import 'existing_cards.dart';


class PaymentOption extends StatefulWidget {
  @override
  _PaymentOptionState createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  onItemPress(BuildContext context, int index) async {
    // print("index: ${index.toString()}");
    switch (index) {
      case 0:
        //payViaNewCard(context);
      //  OrderSheet();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) => OrderSheet()));
        //pay via new card

        break;
      case 1:
      //    Navigator.pushNamed(context, "/ExistingCards");
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ExistingCards();
        }));
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: "Please Wait..."
    );
    await dialog.show();
//    var response= await StripeService.payWithNewCard(
//        amount: "100",
//        currency: "USD"
//    );

    await dialog.hide();
//    Scaffold.of(context).showSnackBar(
//        SnackBar(
//          content: Text(response.message),
//          duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
//        )
//    );
  }

//  @override
//  void initState(){
//    super.initState();
//    StripeService.init();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Payment Option"),
      ),
      body:
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child:

            imageOrientation(context),
          ),
          //  SizedBox(25),
          Padding(
            padding: const EdgeInsets.all(15.0),
            // child: Text("Price: ${foodNotifier.currentFood.price}",style: TextStyle(color: Colors.blueGrey ,fontStyle: FontStyle.italic), textScaleFactor: 1.8,),
            child: textBuild(context),
          ),
          Expanded(
            // padding: EdgeInsets.all(20),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    Icon icon;
                    Text text;
                    switch (index) {
                      case 0:
                        icon = Icon(Icons.add_circle, color: Colors.blueGrey);
                        text = Text("Pay via new card");
                        break;
                      case 1:
                        icon = Icon(Icons.credit_card, color: Colors.blueGrey);
                        text = Text("Pay via Existing Card");
                        break;
                    }
                    return InkWell(
                      onTap: () {
                        debugPrint("Pressed");
                        onItemPress(context, index);
                      },
                      child: ListTile(
                        title: text,
                        leading: icon,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.blueGrey),
                  itemCount: 2)),
        ],
      ),

    );
  }

  imageOrientation(BuildContext context) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);
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
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);
    return Text("Price: ${foodNotifier.currentFood.price}",style: TextStyle(color: Colors.blueGrey ,fontStyle: FontStyle.italic), textScaleFactor: 1.8,);
  }
}