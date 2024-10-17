import 'dart:convert';

import 'package:royal_dry_fruit/repositories/auth_repository.dart';
import 'package:royal_dry_fruit/repositories/home_repository.dart';
import 'package:royal_dry_fruit/repositories/myaccount_repository.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/utils/session_manager.dart';
// import 'package:ecommerce_app_design/views/auth/MobNo_OtpScreen.dart';
// import 'package:ecommerce_app_design/views/auth/Upload_ProfileDet.dart';
import 'package:flutter/material.dart';

class MyAccountViewModel with ChangeNotifier{

  final _repo=MyAccountRepository();
  bool _loading=false;
  bool _loading_address=false;

  var data_list;
  var add_list;
  var cat_list=[];

  bool get loading=>_loading;
  bool get loading_address=>_loading_address;
  setLoading(bool loading){
    _loading=loading;
    notifyListeners();
  }

  setLoadingAddress(bool loading){
    _loading_address=loading;
    notifyListeners();
  }


  late BuildContext context;
  MyAccountViewModel(BuildContext context){
    this.context=context;
    getCustomerDetails( context);

  }


  void getCustomerDetails( BuildContext context)async {
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;
    SessionManager sessionManager=SessionManager();
    // if(true){
    //   setLoading(true);
    //   data_list=Map();
    //   data_list['c_fname']='';
    //   data_list['c_lname']='';
    //   String? email=await sessionManager.getString(SessionManager.KEY_Email);
    //   String? mobile=await sessionManager.getString(SessionManager.KEY_Mobile);
    //   data_list['email']=email==null?"":email;
    //   data_list['mobile']=mobile==null?"":mobile;
    //   setLoading(false);
    //   getDefaultAddress(context);
    //   return;
    // }
    try {

      setLoading(true);
      setLoadingAddress(true);
      _repo.getCustomerDetails("").then((value) {
        setLoading(false);


        if (value['error'] == 1) {
          data_list = value['data'];
          add_list=value['data']['defaultAddress'];
        }
        Utils.prinAppMessages(value.toString());
        setLoadingAddress(false);

      }).onError((error, stackTrace) {
        setLoading(false);
        setLoadingAddress(false);

        Utils.showFlushbarError(error.toString(), context);
        Utils.prinAppMessages(error.toString());
      });
    }catch(e){
      print(e);

    }

   // getDefaultAddress(context);
  }

  // void getDefaultAddress( BuildContext context)async {
  //   // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;
  //   setLoadingAddress(true);
  //   _repo.getDefaultAddress().then((value) {
  //     setLoadingAddress(false);
  //
  //     if(value['error']==0) {
  //       var _address = value['data']['addresses'] as List;
  //       for(int i=0;i<_address.length;i++){
  //         if(_address[i]['setAddressDefault']=="1"){
  //           add_list=_address[i];
  //         }
  //       }
  //
  //     }else {
  //       Utils.showFlushbarError('${value['msg']}',context);
  //     }
  //     Utils.prinAppMessages(value.toString());
  //   }).onError((error, stackTrace) {
  //     setLoading(false);
  //     Utils.showFlushbarError('Error: ${error.toString()}',context);
  //     Utils.prinAppMessages(error.toString());
  //   });
  // }

  logout() async{
    SessionManager sessionManager=SessionManager();
    sessionManager.logout();
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.route_login_signup, (route) => false);
  }
}