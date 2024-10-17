import 'dart:convert';

import 'package:royal_dry_fruit/data/network/base_api_serivices.dart';
import 'package:royal_dry_fruit/data/network/network_api_servises.dart';
import 'package:royal_dry_fruit/res/app_urls.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/session_manager.dart';

class DeliveryAddressRepository{
  BaseApiServices apiServices=NetworkApiServices();

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



  Future<dynamic> getDelveryAddress()async{
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

  Future<dynamic> setDefaultAddress(var data)async{
    try{
      String? session=await SessionManager().getString(SessionManager.KEY_Session);
      String? token=await SessionManager().getString(SessionManager.KEY_Token);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.ep_default_address,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> getStateList()async{
    try{
      String? session=await SessionManager().getString(SessionManager.KEY_Session);
      String? token=await SessionManager().getString(SessionManager.KEY_Token);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.get_state_list_end_point,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> addOrEditAddress(dynamic data)async{
    try{
      String? session=await SessionManager().getString(SessionManager.KEY_Session);
      String? token=await SessionManager().getString(SessionManager.KEY_Token);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.get_add_edit_address_end_point,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> editAddress(dynamic data)async{
    try{
      String? session=await SessionManager().getString(SessionManager.KEY_Session);
      String? token=await SessionManager().getString(SessionManager.KEY_Token);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.ep_edit_address,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> addGSTDetails(var data)async{
    try{
      String? session=await SessionManager().getString(SessionManager.KEY_Session);
      String? token=await SessionManager().getString(SessionManager.KEY_Token);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.get_add_gst_details_end_point,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
   Future<dynamic> getGSTDetails()async{
    try{
      String? session=await SessionManager().getString(SessionManager.KEY_Session);
      String? token=await SessionManager().getString(SessionManager.KEY_Token);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.ep_get_gst,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }

  Future<dynamic> getDeliverySlots()async{
    try{
      String? session=await SessionManager().getString(SessionManager.KEY_Session);
      String? token=await SessionManager().getString(SessionManager.KEY_Token);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.ep_get_delivery_slots,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> getCityList(dynamic data)async{
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
      dynamic response=apiServices.getPostApiResponse(AppUrls.get_city_list_end_point,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }

  Future<dynamic> deleteAddress(var data)async{
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
      dynamic response=apiServices.getPostApiResponse(AppUrls.get_delete_address_end_point,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }



}