import 'package:flutter/material.dart';
import 'package:royal_dry_fruit/res/colors.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';

class AfterReviewScreen extends StatelessWidget {
  var data;
   AfterReviewScreen({this.data,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              Container(padding: EdgeInsets.all(40),child: Image.asset('assests/images/rd_logo.png')),
              SizedBox(height: 10,),
              SizedBox(height: 5,),
              Text('Thank you for your feedback',style: TextStyle(color: Colors.grey,fontSize: 18),),
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
                  color: kButtonColor,
                ),child: Text('CONTINUE SHOPPING',style: TextStyle(color: Colors.white,fontSize: 18)),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
