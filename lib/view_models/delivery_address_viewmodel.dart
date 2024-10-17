import 'dart:convert';

import 'package:royal_dry_fruit/repositories/auth_repository.dart';
import 'package:royal_dry_fruit/repositories/home_repository.dart';
import 'package:royal_dry_fruit/repositories/myaccount_repository.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/session_manager.dart';
// import 'package:ecommerce_app_design/views/auth/MobNo_OtpScreen.dart';
// import 'package:ecommerce_app_design/views/auth/Upload_ProfileDet.dart';
import 'package:flutter/material.dart';

import '../repositories/delivery_address_repository.dart';

class DeliveryAddressViewModel with ChangeNotifier{

  final _repo=DeliveryAddressRepository();

  bool _loading_address=false;
  bool _loading_delete=false;
  bool _loading_default=false;

  var add_list;


  bool get loading_address=>_loading_address;
  bool get loading_delete=>_loading_delete;
  bool get loading_default=>_loading_default;


  setLoadingAddress(bool loading){
    _loading_address=loading;
    notifyListeners();
  }
  setLoadingDelete(bool loading){
    _loading_delete=loading;
    notifyListeners();
  }
  setLoadingDefault(bool loading){
    _loading_default=loading;
    notifyListeners();
  }



  String? _default_add;
  String? get default_add=>_default_add;



  DeliveryAddressViewModel(BuildContext context){

  }

  void getDefaultAddress( BuildContext context)async {
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;

    setLoadingAddress(true);
    _repo.getDelveryAddress().then((value) {

      if(value['error']==0) {
        add_list=value['data']['addresses'];
        for(int i=0;i<(add_list as List).length;i++){
          List _list=(add_list as List);
          if(_list[i]['setAddressDefault']=='1'){

            setDefaultAdd(_list[i]['addr_id']);
          }
        }


      }else if(value['status']==400){
        Utils.showFlushbarError("${value['message']}", context);
      }
      Utils.prinAppMessages(value.toString());

      setLoadingAddress(false);
    }).onError((error, stackTrace) {
      setLoadingAddress(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });

  }

  String? address_delete;
  void deleteAddress( BuildContext context,String address_id)async {
    address_delete=address_id;
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;
    var data=json.encode({
      "address_id":address_id,
      "customer_id":(await  SessionManager().getString(SessionManager.KEY_UserId))!
    });
    Utils.prinAppMessages(data);
    setLoadingDelete(true);
    _repo.deleteAddress(data).then((value) {

      if(value['status']==200) {
        (add_list as List).removeWhere((element) => element['addr_id']==address_id);

      }else if(value['status']==400){
        Utils.showFlushbarError("${value['message']}", context);
      }
      Utils.prinAppMessages(value.toString());

      setLoadingDelete(false);
      address_delete=null;
    }).onError((error, stackTrace) {
      address_delete=null;
      setLoadingDelete(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });

  }

  String? address_default;
  void setDefaultAddress( BuildContext context,String address_id)async {
    address_default=address_id;
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;
    var data=json.encode({
      "address_id":address_id,
    });
    Utils.prinAppMessages(data);
    setLoadingDefault(true);
    _repo.setDefaultAddress(data).then((value) {

      if(value['error']==0) {

        getDefaultAddress(context);

      }else if(value['status']==400){
        Utils.showFlushbarError("${value['message']}", context);
      }
      Utils.prinAppMessages(value.toString());

      setLoadingDefault(false);
      address_default=null;
    }).onError((error, stackTrace) {
      address_default=null;
      setLoadingDefault(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });

  }

  void setDefaultAdd(value) {
    _default_add = value;
    notifyListeners();
  }





}