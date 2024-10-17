import 'dart:convert';

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

class BasketViewModel with ChangeNotifier {
  final _repo = ProductRepository();
  bool _loading = false;
  var DATA = {};
  var data_list = [];
  var save_later_list = [];
  bool _loading_add_to_cart = false;
  bool _loading_delete_from_cart = false;

  bool get loading_delete_from_cart => _loading_delete_from_cart;

  void setLoadingDeleteFromCart(bool loading) {
    _loading_delete_from_cart = loading;
    if (!_loading_delete_from_cart) {
      CART_ID = null;
    }
    notifyListeners();
  }

  bool get loading_add_to_cart => _loading_add_to_cart;

  bool get loading => _loading;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setAddToCart(bool loading) {
    _loading_add_to_cart = loading;
    if (loading == false) {
      PRODUCT_DET = null;
    }
    notifyListeners();
  }

  late BuildContext ctx;

  BasketViewModel(BuildContext context) {
    ctx = context;
  }

  void getBasketList(BuildContext context) async {
    save_later_list=[];
    data_list=[];
    setLoading(true);
    await _repo.getBasket().then((value) {
      setLoading(false);
      if (value['error'] == 0) {
        DATA = value['data'];

        data_list.addAll(value['data']['products']);
        save_later_list.addAll(value['data']['saveLaterProduct']);
        DATA.remove("products");
        DATA.remove("saveLaterProduct");
        calculateTotalPrice();
      } else if (value['status'] == 403) {
        Utils.showFlushbarError(
            value['error'] != null
                ? value['error'].toString()
                : 'Invalid Access',
            context);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.route_login_signup, (route) => false);
      } else {
        Utils.showFlushbarError('${value['msg']}', context);
      }

      Utils.prinAppMessages(value.toString());
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  var PRODUCT_DET;

  void addToCart(String type, var product_det, BuildContext context) async {
    if (_loading_add_to_cart) {
      return;
    }
    PRODUCT_DET = product_det;
    int current_qty = 0;
    try {
      current_qty = int.parse(product_det['cart_qty']);
    }catch(E){print(E);}
      int _qty = 0;
      if (type == '+') {
        _qty++;
        current_qty += 1;
      } else {
        _qty--;
        current_qty -= 1;
        // if(current_qty==1){
        //   deleteFromCart(PRODUCT_DET['cart_id'], context);
        //   PRODUCT_DET=null;
        //   return;
        // }
      }
      var _data = {
        "product_id": product_det['product_id'],
        "variant_id": product_det['variant_id'],
        "qty": _qty,
        "action_type": "2"
      };

      Utils.prinAppMessages(_data);
      setAddToCart(true);
      _repo.addToCart(jsonEncode(_data)).then((value) {

        if (value['error'] == 0) {
          for (int i = 0; i < data_list.length; i++) {
            if (data_list[i]['product_id'] == product_det['product_id'] &&
                data_list[i]['variant_id'] == product_det['variant_id']) {
              if (current_qty == 0) {
                data_list.removeAt(i);
                print('After remove:${data_list.length}');
              } else {
                data_list[i]['cart_qty'] = "$current_qty";
              }
            }
          }
          calculateTotalPrice();
        }
        Utils.prinAppMessages(value.toString());
        setAddToCart(false);
      }).onError((error, stackTrace) {
        print(stackTrace);
        setAddToCart(false);
        Utils.showFlushbarError(error.toString(), context);
        Utils.prinAppMessages(error.toString());
      });
    }


  var CART_ID;

  void deleteFromCart(var element, BuildContext context) async {
    if (_loading_delete_from_cart) {
      return;
    }
    var product_id = element['product_id'];
    CART_ID = element['cart_id'];

    setLoadingDeleteFromCart(true);
    _repo.deleteFromCart(CART_ID).then((value) {

      if (value['error'] == 0) {
        double totalPrice = 0;
        for (int i = 0; i < data_list.length; i++) {
          if (data_list[i]['product_id'] == product_id &&
              data_list[i]['cart_id'] == CART_ID) {
            data_list.removeAt(i);
            print('After remove:${data_list.length}');
          }
        }
        calculateTotalPrice();


      }
      Utils.prinAppMessages(value.toString());
      setLoadingDeleteFromCart(false);
    }).onError((error, stackTrace) {
      print(stackTrace);
      setLoadingDeleteFromCart(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  void calculateTotalPrice() {
    double totalPrice = 0;
    for (int i = 0; i < data_list.length; i++) {
      totalPrice += int.parse(data_list[i]['cart_qty'].toString()) *
          double.parse(data_list[i]['price'].toString());
    }
    DATA['subTotal'] = totalPrice;
  }

  String getProductTotal(var item) {
    return '${(int.parse(item['cart_qty'].toString()) * double.parse(item['price'].toString()))}';
  }

  bool _loading_save_later = false;

  bool get loading_save_later => _loading_save_later;

  setLoadingSaveLater(bool loading) {
    _loading_save_later = loading;
    notifyListeners();
  }

  var SAVE_LATER;
  void addSaveForLater(context, details) {
    SAVE_LATER=details;
    var _data = {
      "cart_id": details['cart_id'],
      "product_id": details['product_id'],
      "variant_id": details['variant_id']
    };

    Utils.prinAppMessages(_data);
    setLoadingSaveLater(true);
    _repo.saveForLater(jsonEncode(_data)).then((value) {
      SAVE_LATER=null;

      if (value['error'] == 1) {
        for (int i = 0; i < data_list.length; i++) {
          if (data_list[i]['product_id'] == details['product_id'] &&
              data_list[i]['variant_id'] == details['variant_id']) {
            data_list.removeAt(i);
          }
        }
        calculateTotalPrice();
      }
      Utils.prinAppMessages(value.toString());
      setLoadingSaveLater(false);
    }).onError((error, stackTrace) {
      SAVE_LATER=null;
      print(stackTrace);
      setLoadingSaveLater(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  void moveToCart(context, details) {
    SAVE_LATER=details;
    var _data = {
      "save_id": details['save_id'],
    };

    Utils.prinAppMessages(_data);
    setLoadingSaveLater(true);
    _repo.moveToCart(jsonEncode(_data)).then((value) {
      SAVE_LATER=null;

      if (value['error'] == 1) {
        for (int i = 0; i < save_later_list.length; i++) {
          if (save_later_list[i]['save_id'] == details['save_id'] &&
              save_later_list[i]['variant_id'] == details['variant_id']) {
            save_later_list.removeAt(i);
          }
        }
        getBasketList(context);
      }
      Utils.prinAppMessages(value.toString());
      setLoadingSaveLater(false);
    }).onError((error, stackTrace) {
      SAVE_LATER=null;
      print(stackTrace);
      setLoadingSaveLater(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }
}
