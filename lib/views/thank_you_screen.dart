

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';


class ThankYou extends StatefulWidget {
  var data;

  ThankYou(this.data);

  @override
  _ThankYouState createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {

  final ScrollController scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var green = Color(0xFF689f39);
    var darkgrey = Color(0xFF7b7c7a);
    var red = Color(0xFFf17523);



    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
        ),
        key: _scaffoldKey,
        body:Container(
          child: Center(
            child: Column(
              children: [
                Container(padding: EdgeInsets.all(40),child: Image.asset('assests/images/rd_logo.png')),
                SizedBox(height: 10,),
                Text('Thank You!',style: TextStyle(color: green,fontSize: 40),),
                SizedBox(height: 5,),
                Text('Your Order has been placed!',style: TextStyle(color: darkgrey,fontSize: 18),),
                SizedBox(height: 10,),
                GestureDetector(
                onTap: (){
                  // Navigator.push(context,MaterialPageRoute(builder: (context)=> OrderDetScreen()));
                  Navigator.pushNamed(context, RouteNames.route_my_orders_screen);

                }
                ,child: Text('Order No: ${widget.data}',style: TextStyle(decoration: TextDecoration.underline,color: darkgrey,fontSize: 16),)),
                SizedBox(height: 15,),
                GestureDetector(
                  onTap: (){
                    // Navigator.push(context,MaterialPageRoute(builder: (context)=> main_screen()));
                    Navigator.pushNamedAndRemoveUntil(context, RouteNames.route_home,(Route<dynamic> route) => false);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30,10,30,10)
                    ,decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: red,
                  ),child: Text('CONTINUE SHOPPING',style: TextStyle(color: Colors.white,fontSize: 18)),),
                )
              ],
            ),
          ),
        )
    );
  }

}






