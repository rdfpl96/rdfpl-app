import 'dart:convert';

import 'package:flutter/material.dart';

import '../repositories/product_repository.dart';
import '../utils/Utils.dart';
import '../utils/session_manager.dart';

class CouponsViewModel with ChangeNotifier{
  final _repo = ProductRepository();
  bool _is_loading = false;
  TextEditingController tec_coupon=TextEditingController();

  bool get is_loading => _is_loading;


  var list_product;

  void setLoading(bool loading) {
    _is_loading = loading;
    notifyListeners();
  }

  late BuildContext context;

  var data;

  CouponsViewModel(BuildContext context,var data) {
    this.context = context;
    this.data=data;
    tec_coupon.text="L9E2NM";

    Utils.prinAppMessages("CopData:$data");
    getCoupons();

  }


  void applyCoupon() async {
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;
    var data = json.encode({
      // "customer_id": (await SessionManager().getString(
      //     SessionManager.KEY_UserId))!,
        "coupon_code":tec_coupon.text,
        // "total_purchaseAmount":this.data['total_amount'],
        // "total_itemsWeightKg":this.data['total_itemsWeightKg']

    });
    Utils.prinAppMessages(data);
    setLoading(true);
    _repo.applyCoupon(data).then((value) {
      if (value['error'] == 0) {
        //{"error":0,"msg":"Success","data":{"totalSellingPrice":399,"totalMrpPrice":429,"totalSave":30,"totalPayAmout":399,"shipingcharge":0,"couponDisc":0}}
        // Navigator.pop(context,value['response']);
        var resultDat=value['data'];
        resultDat['coupon_code']=tec_coupon.text;
        Navigator.pop(context,resultDat);

      } else  {
        Utils.showFlushbarError("${value['msg']}", context);
      }
      Utils.prinAppMessages(value.toString());

      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  bool _is_loading_data = false;

  bool get is_loading_data => _is_loading_data;


  var list_coupons;

  void setLoadingData(bool loading) {
    _is_loading_data = loading;
    notifyListeners();
  }
  void getCoupons() async {

    Utils.prinAppMessages(data);
    setLoadingData(true);
    _repo.getCoupons().then((value) {
      if (value['error'] == 0) {
        list_coupons=value['data'] as List;

      } else if (value['status'] == 400) {
        Utils.showFlushbarError("${value['message']}", context);
      }
      Utils.prinAppMessages(value.toString());

      setLoadingData(false);
    }).onError((error, stackTrace) {
      setLoadingData(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }
}