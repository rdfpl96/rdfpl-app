import 'dart:convert';

import 'package:flutter/material.dart';

import '../repositories/product_repository.dart';
import '../utils/Utils.dart';

class SaveLaterViewModel with ChangeNotifier {
  final _repo = ProductRepository();
  var list = [];

  SaveLaterViewModel(var list) {
    this.list = list;
    print("Data:::::::::::::\n$list");
  }


  // Loading
  bool _loading_save_later = false;
  bool get loading_save_later => _loading_save_later;
  setLoadingSaveLater(bool loading) {
    _loading_save_later = loading;
    notifyListeners();
  }
// End Loading
  var SAVE_LATER;

  void moveToCart(context, details) {
    SAVE_LATER = details;
    var _data = {
      "save_id": details['save_id'],
    };

    Utils.prinAppMessages(_data);
    setLoadingSaveLater(true);
    _repo.moveToCart(jsonEncode(_data)).then((value) {
      SAVE_LATER = null;

      if (value['error'] == 1) {
        for (int i = 0; i < list.length; i++) {
          if (list[i]['save_id'] == details['save_id'] &&
              list[i]['variant_id'] == details['variant_id']) {
            list.removeAt(i);
          }
        }
      }
      Utils.prinAppMessages(value.toString());
      setLoadingSaveLater(false);
    }).onError((error, stackTrace) {
      SAVE_LATER = null;
      print(stackTrace);
      setLoadingSaveLater(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }



  var PRODUCT_DET;
  bool _loading_add_to_cart = false;
  bool get loading_add_to_cart => _loading_add_to_cart;

  setAddToCart(bool loading) {
    _loading_add_to_cart = loading;
    if (loading == false) {
      PRODUCT_DET = null;
    }
    notifyListeners();
  }

  void addToCart(String type, var product_det, BuildContext context) async {
    if (_loading_add_to_cart) {
      return;
    }
    PRODUCT_DET = product_det;
    int current_qty = 0;
    try {
      current_qty = int.parse(product_det['cart_qty']);
    }catch(e){
      print(e);
    }

      int _qty = 0;
      if (type == '+') {
        _qty++;
        current_qty += 1;
      } else {
        _qty--;
        current_qty -= 1;
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
          for (int i = 0; i < list.length; i++) {
            if (list[i]['product_id'] == product_det['product_id'] &&
                list[i]['variant_id'] == product_det['variant_id']) {
              if (current_qty == 0) {
                list.removeAt(i);
                print('After remove:${list.length}');
              } else {
                list[i]['cart_qty'] = "$current_qty";
              }
            }
          }
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


  // Loading
  bool _loading_delete = false;
  bool get loading_delete => _loading_delete;
  setLoadingDelete(bool loading) {
    _loading_delete = loading;
    notifyListeners();
  }
// End Loading

var ITEM;
  void deleteFromSaveLater(context, details) {
    ITEM = details;
    var _data = "${details['save_id']}";

    setLoadingDelete(true);
    _repo.deleteSaveLater(_data).then((value) {
      ITEM = null;

      if (value['error'] == 0) {
        for (int i = 0; i < list.length; i++) {
          if (list[i]['save_id'] == details['save_id'] &&
              list[i]['variant_id'] == details['variant_id']) {
            list.removeAt(i);
          }
        }
      }
      Utils.prinAppMessages(value.toString());
      setLoadingDelete(false);
    }).onError((error, stackTrace) {
      ITEM = null;
      print(stackTrace);
      setLoadingDelete(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

}
