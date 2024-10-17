import 'dart:convert';

import 'package:royal_dry_fruit/data/network/base_api_serivices.dart';
import 'package:royal_dry_fruit/data/network/network_api_servises.dart';
import 'package:royal_dry_fruit/res/app_urls.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/session_manager.dart';

class MyAccountRepository{
  BaseApiServices apiServices=NetworkApiServices();

  Future<dynamic> getCustomerDetails(dynamic data)async{
    try{
      String? session=await SessionManager().getString(SessionManager.KEY_Session);
      String? token=await SessionManager().getString(SessionManager.KEY_Token);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.getcustomerdetails_end_point,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> getDefaultAddress()async{
    try{
      String? session=await SessionManager().getString(SessionManager.KEY_Session);
      String? token=await SessionManager().getString(SessionManager.KEY_Token);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.ep_addresslist,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
}