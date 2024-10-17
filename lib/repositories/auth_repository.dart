

import 'dart:convert';

import 'package:royal_dry_fruit/data/network/base_api_serivices.dart';
import 'package:royal_dry_fruit/data/network/network_api_servises.dart';
import 'package:royal_dry_fruit/res/app_urls.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/session_manager.dart';

class AuthRepository{
  BaseApiServices apiServices=NetworkApiServices();
  Future<dynamic> login(dynamic data)async{
    try{
      dynamic response=apiServices.getPostApiResponse(AppUrls.login_with_mobile, data);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> login_email(dynamic data)async{
    try{
      dynamic response=apiServices.getPostApiResponse(AppUrls.login_with_email, data);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> verifyotp(dynamic data,[bool is_auth=false])async{
    String? session=await SessionManager().getString(SessionManager.KEY_Session);
    try{
      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
      };
      if(is_auth){
        String? token=await SessionManager().getString(SessionManager.KEY_Token);
        headers['Authorization'] = token!;
      }

      dynamic response=apiServices.getPostApiResponse(AppUrls.verify_otp_by_mobile, data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> resendOtpEmail(dynamic data)async{
    String? session=await SessionManager().getString(SessionManager.KEY_Session);
    try{
      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
      };

      dynamic response=apiServices.getPostApiResponse(AppUrls.rp_resend_otp_email, data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> resendOtpMobile(dynamic data)async{
    String? session=await SessionManager().getString(SessionManager.KEY_Session);
    try{
      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
      };

      dynamic response=apiServices.getPostApiResponse(AppUrls.rp_resend_otp_mobile, data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> verifyotp_email(dynamic data,[bool is_auth=false])async{
    String? session=await SessionManager().getString(SessionManager.KEY_Session);
    try{
      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
      };
      if(is_auth){
        String? token=await SessionManager().getString(SessionManager.KEY_Token);
        headers['Authorization'] = token!;
      }
      dynamic response=apiServices.getPostApiResponse(AppUrls.verify_otp_by_email, data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }

  Future<dynamic> updateuserdetails(dynamic data)async{
    try{
      String? session=await SessionManager().getString(SessionManager.KEY_Session);
      String? token=await SessionManager().getString(SessionManager.KEY_Token);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.updateuserdetails_end_point, data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
}