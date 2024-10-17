import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CancelOrder extends StatefulWidget {
  @override
  _CancelOrderState createState() => _CancelOrderState();
}

class _CancelOrderState extends State<CancelOrder>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var green = Color(0xFF689f39);
    var darkgrey = Color(0xFF7b7c7a);
    var red = Color(0xFFf17523);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: green,
            child: Icon(CupertinoIcons.back),
          ),
        ),
       // backgroundColor:green,
        title: Text(
          'Cancel Order',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,



      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                margin: EdgeInsets.fromLTRB(20,20,20,5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xff005c66),
                        borderRadius: BorderRadius.only(
                          topLeft:   Radius.circular(10),topRight:   Radius.circular(10)
                        ),
                      ),

                      child: Row(
                        children: [
                          Container(padding: EdgeInsets.all(7),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xff389ca7),
                                borderRadius: BorderRadius.all(Radius.circular(50))
                              ),
                              child: Image.asset('assests/images/bike.png',width: 20,)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Today 03:00 pm - 05:00pm',style: TextStyle(fontSize: 12,color: Colors.white),),
                            Text('To pay: Rs 500.50',style: TextStyle(fontSize: 12,color: Colors.white),),

                          ],
                          )
                        ],
                      ),
                    ),
                    Container(margin: EdgeInsets.only(left: 20,top: 10),child: Text('Select a reason to cancel',style: TextStyle(color: Colors.black.withOpacity(0.7)))),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      color: Colors.grey,
                      height: 0.5,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Radio(value: false, groupValue: null, onChanged: ( value) {  },),
                          Text('I am not at a home',style: TextStyle(color: darkgrey)),

                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      height: 0.5,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Radio(value: false, groupValue: null, onChanged: ( value) {  },),
                          Text('I placed a wrong order',style: TextStyle(color: darkgrey)),

                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      height: 0.5,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Radio(value: false, groupValue: null, onChanged: ( value) {  },),
                          Text('I forgot to apply voucher',style: TextStyle(color: darkgrey)),

                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      height: 0.5,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Radio(value: false, groupValue: null, onChanged: ( value) {  },),
                          Text('I forgot to add additional products/items',style: TextStyle(color: darkgrey)),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
