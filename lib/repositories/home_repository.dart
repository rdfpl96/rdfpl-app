import 'dart:convert';

import 'package:royal_dry_fruit/data/network/base_api_serivices.dart';
import 'package:royal_dry_fruit/data/network/network_api_servises.dart';
import 'package:royal_dry_fruit/res/app_urls.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/session_manager.dart';

class HomeRepository{
  BaseApiServices apiServices=NetworkApiServices();

  Future<dynamic> getHomeDetails()async{
    try{
      String? session=await SessionManager().getString(SessionManager.KEY_Session);
      String? token=await SessionManager().getString(SessionManager.KEY_Token);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.ep_home,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }



  /*These are the old API's*/

  Future<dynamic> getCategories()async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String username = 'royal';
      String password = 'royal2023';
      String basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));
      Map<String,String> headers={
        "X-API-KEY": token!,
        "Content-Type":"application/json",
        "authorization":basicAuth
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.getcategory_end_point,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> getDashboardDetails()async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String username = 'royal';
      String password = 'royal2023';
      String basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));
      Map<String,String> headers={
        "X-API-KEY": token!,
        "Content-Type":"application/json",
        "authorization":basicAuth
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.get_dashboard_details_end_point,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> getCustomerDetails(dynamic data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String username = 'royal';
      String password = 'royal2023';
      String basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));
      Map<String,String> headers={
        "X-API-KEY": token!,
        "Content-Type":"application/json",
        "authorization":basicAuth
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.getcustomerdetails_end_point, data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
}