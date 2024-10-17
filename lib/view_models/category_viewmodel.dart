import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:royal_dry_fruit/repositories/auth_repository.dart';
import 'package:royal_dry_fruit/repositories/home_repository.dart';
import 'package:royal_dry_fruit/repositories/product_repository.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/utils/session_manager.dart';
// import 'package:ecommerce_app_design/views/auth/MobNo_OtpScreen.dart';
// import 'package:ecommerce_app_design/views/auth/Upload_ProfileDet.dart';
import 'package:flutter/material.dart';

import 'home_viewmodel.dart';

class CategoryViewModel with ChangeNotifier{


  final _repo=ProductRepository();
  bool _loading=false;
  var cat_list=[];


  bool get loading=>_loading;

  setLoading(bool loading){
    _loading=loading;
    notifyListeners();
  }


  late BuildContext ctx;
  CategoryViewModel(BuildContext context){
    ctx=context;

  }



  void getCategory( BuildContext context)async {


    setLoading(true);
    await _repo.getCategory().then((value) {

        setLoading(false);

        if(value['error']==0) {
          cat_list=value['data']['category'];

        }

        Utils.prinAppMessages(value.toString());

    }).onError((error, stackTrace) {

      setLoading(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });
  }

  void setSelected(itm, bool value) {
    for(int i=0;i<cat_list.length;i++){
      if(cat_list[i]['cat_id']==itm['cat_id']){
        cat_list[i]['is_selected']=value;
        notifyListeners();
        return;
      }
    }
  }

}