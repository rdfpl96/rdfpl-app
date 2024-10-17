import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:royal_dry_fruit/repositories/product_repository.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';

import '../utils/session_manager.dart';

class OrderDetailsViewModel with ChangeNotifier{
  var _repo=ProductRepository();

  BuildContext context;
  var data;

  bool _loading=false;


  bool get loading=>_loading;
  setLoading(bool loading){
    _loading=loading;
    notifyListeners();
  }

  OrderDetailsViewModel(this.context,var data){
    this.data=data;
    Utils.prinAppMessages("DATA:$data");
  }

  checkIsSaving() {
    double total_amt=double.parse(data['order_total_purchase_amount']==null?"0":data['order_total_purchase_amount'].toString());
    double total_purchase_amt=double.parse(data['order_total_final_amt']==null?"0":data['order_total_final_amt'].toString());
    // total_amt=102.2;
    // total_purchase_amt=90.2;
    if((total_amt-total_purchase_amt)==0){
      return false;
    }else{
      return true;
    }
  }

  String getSavingAmount(){
    double total_amt=double.parse(data['order_total_purchase_amount'].toString());
    double total_purchase_amt=double.parse(data['order_total_final_amt'].toString());
    // total_amt=102.2;
    // total_purchase_amt=90.2;
    return "${total_amt-total_purchase_amt}";
  }

  void cancelOrder( BuildContext context)async {
  var raw_data=jsonEncode({
    "customer_id":(await  SessionManager().getString(SessionManager.KEY_UserId))!,
    "order_id":data['order_generated_order_id'] ,
    "reason_id":"1"
  });

    Utils.prinAppMessages(raw_data);
    setLoading(true);
    _repo.orderCancel(raw_data).then((value) {
      setLoading(false);
      Utils.showFlushbarError(value['message'],context);

      if(value['status']==200) {

        Utils.showFlushbarError("Success", context);

      }
      Utils.prinAppMessages(value.toString());
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });
  }


}