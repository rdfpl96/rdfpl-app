import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:royal_dry_fruit/view_models/splash_viewmodel.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SplashViewModel provider=Provider.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(

      body: Container(
        color:  Color(0xFFFf6f9f3),
        child: Center(

          child:  Container(
            margin: EdgeInsets.all(50),
            child: Image.asset("assests/images/rd_logo.png",fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
