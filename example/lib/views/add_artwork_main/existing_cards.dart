import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';



class ExistingCards extends StatefulWidget {
  @override
  _ExistingCardsState createState() => _ExistingCardsState();
}

class _ExistingCardsState extends State<ExistingCards> {

  List cards = [{

    "cardNumber": "4242424242424242",
    "expiryDate": "04/24",
    "cardHolderName": "Ashley Mooney",
    "cvvCode": "424",
    "showBackView": false, //true when you want to show cvv(back) view

  },
    {
      "cardNumber": "4000056655665556",
      "expiryDate": "04/24",
      "cardHolderName": "Gordon Mooney",
      "cvvCode": "424",
      "showBackView": false, //true when you want to show cvv(back) view
    }

  ];

  payViaExistingCard(BuildContext context, card) {
//Navigator.pop(context);
////  debugPrint("yes");
//    var response = StripeService.payViaExistingCard(
//      amount: "150",
//      currency: "USD",
//      card: card,
//    );
//    if (response.success == true) {
//      Scaffold
//          .of(context)
//          .showSnackBar(
//          SnackBar(
//            content: Text(response.message),
//            duration: new Duration(milliseconds: 1200),
//          )
//      )
//          .closed
//          .then((_) {
//        Navigator.pop(context);
//      });
//    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Existing Card"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index){
            var card = cards[index];
            return InkWell(
              onTap: (){
                payViaExistingCard(context,card);
              },
              child: CreditCardWidget(

                cardNumber: card["cardNumber"],
                expiryDate: card["expiryDate"],
                cardHolderName: card["cardHolderName"],
                cvvCode: card["cvvCode"],
                showBackView: false, //true when you want to show cvv(back) view
              ),
            );
          },
        ),
      ),
    );
  }
}
