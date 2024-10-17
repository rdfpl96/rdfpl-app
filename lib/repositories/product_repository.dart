import 'dart:convert';

import 'package:royal_dry_fruit/data/network/base_api_serivices.dart';
import 'package:royal_dry_fruit/data/network/network_api_servises.dart';
import 'package:royal_dry_fruit/res/app_urls.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/session_manager.dart';

class ProductRepository{
  BaseApiServices apiServices=NetworkApiServices();


  Future<dynamic> getWishList()async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.ep_whishlist,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> addToCart(dynamic data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.ep_add_to_cart,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> deleteWhishlist(dynamic data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.ep_delete_whishlist+data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> saveForLater(dynamic data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.ep_save_for_later,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> moveToCart(dynamic data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.ep_move_to_cart,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }

  Future<dynamic> deleteSaveLater(dynamic data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.ep_delete_save_later+data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> deleteFromCart(dynamic data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.ep_delete_from_cart+data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> addToWhishList(dynamic data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.ep_add_to_whishlist,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> getMyRatings()async{
    try{
      String? session=await SessionManager().getString(SessionManager.KEY_Session);
      String? token=await SessionManager().getString(SessionManager.KEY_Token);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.ep_my_ratings,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> getBasket()async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.ep_cart,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> getCategory()async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.ep_category_list,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }


  Future<dynamic> getProduct(var data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.ep_getproductlist,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> giveRateAndReview(var data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.ep_rate_review,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> getProductDetails(dynamic data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.getproduct_details_end_point+(data),headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> doCheckout()async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.ep_checkout,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> placeOrder(dynamic data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.get_place_order_end_point,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  /*Theese are old API's*/



  // Future<dynamic> addToCart(dynamic data)async{
  //   try{
  //     String? token=await SessionManager().getString(SessionManager.KEY_Token);
  //     String username = 'royal';
  //     String password = 'royal2023';
  //     String basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));
  //     Map<String,String> headers={
  //       "X-API-KEY": token!,
  //       "Content-Type":"application/json",
  //       "authorization":basicAuth
  //     };
  //     dynamic response=apiServices.getPostApiResponse(AppUrls.get_add_to_cart_end_point,data,headers);
  //     return response;
  //   }catch(e){
  //     Utils.prinAppMessages(e.toString());
  //   }
  // }
  // Future<dynamic> deleteFromCart(dynamic data)async{
  //   try{
  //     String? token=await SessionManager().getString(SessionManager.KEY_Token);
  //     String username = 'royal';
  //     String password = 'royal2023';
  //     String basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));
  //     Map<String,String> headers={
  //       "X-API-KEY": token!,
  //       "Content-Type":"application/json",
  //       "authorization":basicAuth
  //     };
  //     dynamic response=apiServices.getPostApiResponse(AppUrls.get_delte_from_cart_end_point,data,headers);
  //     return response;
  //   }catch(e){
  //     Utils.prinAppMessages(e.toString());
  //   }
  // }
  Future<dynamic> searchProduct(dynamic data)async{
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
      dynamic response=apiServices.getPostApiResponse(AppUrls.get_search_product_end_point,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> applyCoupon(dynamic data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getPostApiResponse(AppUrls.get_apply_coupon_end_point,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> getCoupons()async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.get_get_coupons_ep,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> orderHistory(dynamic data)async{
    try{
      String? token=await SessionManager().getString(SessionManager.KEY_Token);
      String? session=await SessionManager().getString(SessionManager.KEY_Session);

      Map<String,String> headers={
        "Content-Type":"application/json",
        "cookie":session!,
        "Authorization":token!
      };
      dynamic response=apiServices.getGetApiResponse(AppUrls.get_order_list_end_point+data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> orderCancel(dynamic data)async{
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
      dynamic response=apiServices.getPostApiResponse(AppUrls.get_order_cancel_end_point,data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
  Future<dynamic> getProductRating(dynamic data)async{
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
      dynamic response=apiServices.getGetApiResponse(AppUrls.get_product_rating_end_point+data,headers);
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }

}