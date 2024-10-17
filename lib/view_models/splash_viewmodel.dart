import 'dart:async';
import 'dart:convert';

import 'package:royal_dry_fruit/repositories/auth_repository.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/utils/session_manager.dart';
import 'package:flutter/material.dart';

import '../utils/AppUtils.dart';
import 'package:flutter/material.dart';
class SplashViewModel with ChangeNotifier{
  late BuildContext context;
  SplashViewModel(BuildContext context){
    this.context=context;
    init();
  }

  void init()async {
    Status_bar();
    SessionManager sessionManager=SessionManager();
    String? token=await sessionManager.getString(SessionManager.KEY_Token);
    if(token!=null && token!=''){
      Timer(Duration(seconds: 3), () {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => IntroPage()),
        //   //   MaterialPageRoute(builder: (context) => AutoCompleteSample()),
        // );
        Navigator.pushReplacementNamed(context, RouteNames.route_home);
      });
    }else{
      Navigator.pushReplacementNamed(context, RouteNames.route_login_signup);

    }

  }
}