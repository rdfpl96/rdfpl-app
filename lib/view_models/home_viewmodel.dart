import 'dart:convert';

import 'package:royal_dry_fruit/repositories/auth_repository.dart';
import 'package:royal_dry_fruit/repositories/home_repository.dart';
import 'package:royal_dry_fruit/repositories/myaccount_repository.dart';
import 'package:royal_dry_fruit/repositories/product_repository.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/session_manager.dart';

// import 'package:royal_dry_fruit/views/auth/MobNo_OtpScreen.dart';
// import 'package:ecommerce_app_design/views/auth/Upload_ProfileDet.dart';
import 'package:flutter/material.dart';

import '../repositories/delivery_address_repository.dart';
import '../utils/routes/routes_name.dart';

class HomeViewModel with ChangeNotifier {
  ProductRepository _repoProduct = ProductRepository();
  MyAccountRepository _repoAccount = MyAccountRepository();
  int _selectedIndex = 0;
  int cat_id = 0;
  int sub_cat_id = 0;
  int child_cat_id = 0;
  var header_data;
  double? hidable;

  var cart_count = 0;
  var whishlist_count = 0;

  changeCartCount(int val) {
    cart_count = val;
    Utils.prinAppMessages(
        "Changing Cart Count:${cart_count} :*****************************************");

    notifyListeners();
  }
  changeWhishlistCount(int val) {
    whishlist_count = val;
    Utils.prinAppMessages(
        "Changing Whishlist Count:${whishlist_count} :*****************************************");

    notifyListeners();
  }

  void setHidable(double visibility) {
    hidable = visibility;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;

  void selectedIndexOfNavigation(int value) {
    if (value >= 4) {
      return;
    }
    _selectedIndex = value;
    notifyListeners();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  final _homeRepo = HomeRepository();
  final _repo = DeliveryAddressRepository();

  bool _loading = false;
  var default_address;
  var data_list = [];
  var cat_list = [];
  var mySmartProduct = [];
  var myFeatureProduct = [];
  var myNewProduct = [];

  bool get loading => _loading;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  bool add_btn = true;
  bool plusminus = false;

  void addbtn() {
    add_btn = false;
    plusminus = true;
    notifyListeners();
  }

  void plusminusbtn() {
    add_btn = true;
    plusminus = false;
  }

  var add_list;
  BuildContext? ctx;

  HomeViewModel(BuildContext context) {
    this.ctx = context;
    var data = {"banner_type": "banner"};
     getDashboardDetails(data, context);

  }

  /**
   * Loading Default Address
   *
   * */

  bool _loading_address = false;

  bool get loading_address => _loading_address;
  var cust_details;
  setLoadingAddress(bool loading) {
    _loading_address = loading;
    notifyListeners();
  }

  void getDefaultAddress(BuildContext context) async {
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;

    default_address = null;
    setLoadingAddress(true);
    await _repoAccount.getCustomerDetails("").then((value) {
      setLoading(false);


      if (value['error'] == 1) {
        cust_details = value['data'];
        default_address=value['data']['defaultAddress'];

      }
      Utils.prinAppMessages(value.toString());
      setLoadingAddress(false);

    }).onError((error, stackTrace) {
      setLoading(false);
      setLoadingAddress(false);

      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });

    getWhishList();
    // _repo.getDefaultAddress().then((value) {
    //   if (value['error'] == 0) {
    //     var _address = value['data']['addresses'] as List;
    //     for(int i=0;i<_address.length;i++){
    //       if(_address[i]['setAddressDefault']=="1"){
    //         default_address=_address[i];
    //       }
    //     }
    //   } else if (value['status'] == 400) {
    //     Utils.showFlushbarError("${value['message']}", context);
    //   }
    //   Utils.prinAppMessages(value.toString());
    //
    //   setLoadingAddress(false);
    // }).onError((error, stackTrace) {
    //   setLoadingAddress(false);
    //   Utils.showFlushbarError(error.toString(), context);
    //   Utils.prinAppMessages(error.toString());
    // });
  }

  /**
   * Loading Default Address
   *
   * */
  /**
   * Add To Cart
   *
   * */

  bool _loading_add_to_cart = false;

  bool get loading_add_to_cart => _loading_add_to_cart;

  setLoadingAddToCart(bool value) {
    _loading_add_to_cart = value;
    notifyListeners();
  }

  var PRODUCT_DET;

  void addToCart(int index, String type, BuildContext context, {prod_type = 'S'}) async {
    if (_loading_add_to_cart) {
      return;
    }
    var product_det;
    if (prod_type == 'S') {
      product_det = mySmartProduct[index];
    } else if (prod_type == 'N') {
      product_det = myNewProduct[index];
    }else if (prod_type == 'F') {
      product_det = myFeatureProduct[index];
    }
    PRODUCT_DET = product_det;

    var selected_item = getSelected(prod_type,index);
    int prod_qty = selected_item['qty'] == null
        ? 0
        : int.parse(selected_item['qty'].toString());
    // if(prod_qty==1 && type=='-'){
    //   await deleteFromCart(selected_item,index,context,prod_type: prod_type);
    //
    //   return;
    //
    // }
    int _qty = 0;

    if (type == '+') {
      _qty++;
      prod_qty++;
    } else {
      _qty--;
      prod_qty--;
    }
    Map raw_data = {
      "product_id": product_det['product_id'],
      "variant_id": selected_item['variant_id'],
      "qty": _qty,
      "action_type": "2"
    };

    Utils.prinAppMessages(raw_data);
    setLoadingAddToCart(true);
    _repoProduct.addToCart(jsonEncode(raw_data)).then((value) {
      Utils.prinAppMessages(value.toString());
      if (value['error'] == 0) {
        
        if (prod_type == 'S') {
          for (int i = 0;i < (mySmartProduct[index]['items'] as List).length; i++) {
            if (mySmartProduct[index]['items'][i]['is_selected'] == true) {
              mySmartProduct[index]['items'][i]['qty'] = "$prod_qty";
            }
          }
        } else if (prod_type == 'F') {
          for (int i = 0; i < (myFeatureProduct[index]['items'] as List).length; i++) {
            if (myFeatureProduct[index]['items'][i]['is_selected'] == true) {
              myFeatureProduct[index]['items'][i]['qty'] = "$prod_qty";
            }
          }
        }else if (prod_type == 'N') {
          for (int i = 0; i < (myNewProduct[index]['items'] as List).length; i++) {
            if (myNewProduct[index]['items'][i]['is_selected'] == true) {
              myNewProduct[index]['items'][i]['qty'] = "$prod_qty";
            }
          }
        }
        getBasketList();
      } else {
        Utils.showFlushbarError(value['msg'], context);
      }

      // Utils.showFlushbarError(value['message'],context);

      // if(value['status']==200) {
      //   var _items=value['response'] as List;
      //   print('Cart Count:${_items.length} *****************************************');
      //   for(int x=0;x<_items.length;x++){
      //
      //     if(_items[x]['product_id']==product_det['product_id'] && _items[x]['variant_id']==selected_item['variant_id']){
      //       for(int a=0;a<(data_list[index]['variants']as List).length;a++){
      //         if(data_list[index]['variants'][a]['variant_id']==selected_item['variant_id']){
      //           data_list[index]['variants'][a]['qty']=_items[x]['qty'];
      //           data_list[index]['variants'][a]['cart_id']=_items[x]['cart_id'];
      //           break;
      //         }
      //       }
      //       // data_list[index]['qty']=_items[x]['qty'];
      //
      //     }
      //   }
      //   updateBadge(_items.length,null);
      //   Utils.showFlushbarError(value['message'], context);
      //   Future.delayed(Duration(seconds: 3),() {
      //     // Navigator.push(
      //     //   context,
      //     //   MaterialPageRoute(builder: (context) => Upload_ProfileDet(data:value['response'])),
      //     // );
      //   },);
      //
      // }

      setLoadingAddToCart(false);
    }).onError((error, stackTrace) {
      print(stackTrace);
      setLoadingAddToCart(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  /**
   * Add To Cart
   *
   * */



// Selected Variant - to highlight selected vaiant in modalsheet
  void setSelectedVarient(index, val, {prod_type = 'S'}) {
    var _main_data;
    if (prod_type == 'S') {
      for (int x = 0;
          x < (mySmartProduct[index]['items'] as List).length;
          x++) {
        bool is_selected = false;
        if (mySmartProduct[index]['items'][x]['variant_id'] ==
            val['variant_id']) {
          is_selected = true;
        }
        mySmartProduct[index]['items'][x]['is_selected'] = is_selected;
      }
    } else if (prod_type == 'F') {
      for (int x = 0;
          x < (myFeatureProduct[index]['items'] as List).length;
          x++) {
        bool is_selected = false;
        if (myFeatureProduct[index]['items'][x]['variant_id'] ==
            val['variant_id']) {
          is_selected = true;
        }
        myFeatureProduct[index]['items'][x]['is_selected'] = is_selected;
      }
    }else if (prod_type == 'N') {
      for (int x = 0;
          x < (myNewProduct[index]['items'] as List).length;
          x++) {
        bool is_selected = false;
        if (myNewProduct[index]['items'][x]['variant_id'] ==
            val['variant_id']) {
          is_selected = true;
        }
        myNewProduct[index]['items'][x]['is_selected'] = is_selected;
      }
    }

    notifyListeners();
  }

// Selected Variant  - to highlight selected vaiant in modalsheet

  //Select selected product variant from the index
  getSelected(var prod_type,int index) {
    if (prod_type == 'S') {
      for (int i = 0; i < (mySmartProduct[index]['items'] as List).length; i++) {
        if (mySmartProduct[index]['items'][i]['is_selected'] == true) {
          return mySmartProduct[index]['items'][i];
        }
      }
    } else if (prod_type == 'N') {
      for (int i = 0; i < (myNewProduct[index]['items'] as List).length; i++) {
        if (myNewProduct[index]['items'][i]['is_selected'] == true) {
          return myNewProduct[index]['items'][i];
        }
      }
    }else if (prod_type == 'F') {
      for (int i = 0; i < (myFeatureProduct[index]['items'] as List).length; i++) {
        if (myFeatureProduct[index]['items'][i]['is_selected'] == true) {
          return myFeatureProduct[index]['items'][i];
        }
      }
    }

  }

  //Select selected product variant from the index
  // **************************************************************************************************************************
  // Add To Cart Functionality ****************************************************************************
  // **************************************************************************************************************************

  void getDashboardDetails(Map data, BuildContext context) {
    Utils.prinAppMessages(data);
    setLoading(true);
    _homeRepo.getHomeDetails().then((value) {
      setLoading(false);

      if (value['error'] == 0) {
        data_list = value['data']['baners'];
        cat_list = value['data']['shopByCategory'];
        mySmartProduct = value['data']['mySmartProduct'];
        myFeatureProduct = value['data']['myFeatureProduct'];
        myNewProduct = value['data']['myNewroduct'];

        if (mySmartProduct != null && mySmartProduct.length > 0) {
          for (int i = 0; i < mySmartProduct.length; i++) {
            for (int j = 0;
                j < (mySmartProduct[i]['items'] as List).length;
                j++) {
              // mySmartProduct[i]['items']['qty']=0;
              mySmartProduct[i]['items'][j]['is_selected'] = false;
              if (j == 0) {
                mySmartProduct[i]['items'][j]['is_selected'] = true;
              }
            }
          }
        }
        if (myFeatureProduct != null && myFeatureProduct.length > 0) {
          for (int i = 0; i < myFeatureProduct.length; i++) {
            for (int j = 0; j < (myFeatureProduct[i]['items']).length; j++) {
              // mySmartProduct[i]['items']['qty']=0;
              if (j == 0) {
                myFeatureProduct[i]['items'][j]['is_selected'] = true;
              }
            }
          }
        }
        if (myNewProduct != null && myNewProduct.length > 0) {
          for (int i = 0; i < myNewProduct.length; i++) {
            for (int j = 0; j < (myNewProduct[i]['items']).length; j++) {
              // mySmartProduct[i]['items']['qty']=0;
              if (j == 0) {
                myNewProduct[i]['items'][j]['is_selected'] = true;
              }
            }
          }
        }
        print('catlist Size=====================${cat_list.length}');
      } else {
        Utils.prinAppMessages(value.toString());
      }
      getBasketList();
    }).onError((error, stackTrace) {
      print("Error In Home API:$error");
      print(stackTrace);
      setLoading(false);
      getBasketList();

      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  var cart_list = [];
  bool _loading_basket = false;
  bool get loading_basket => _loading_basket;

  setLoadingBasket(bool value) {
    _loading_basket = value;
    notifyListeners();
  }
  Future<void> getBasketList() async {
    cart_list.clear();
    setLoadingBasket(true);
    await _repoProduct.getBasket().then((value) {
      cart_list.clear();

      if (value['error'] == 0) {
        cart_list.addAll(value['data']['products']);

      } else if (value['status'] == 403) {
        Utils.showFlushbarError(
            value['error'] != null
                ? value['error'].toString()
                : 'Invalid Access',
            ctx!);
        Navigator.pushNamedAndRemoveUntil(
            ctx!, RouteNames.route_login_signup, (route) => false);
      }

      changeCartCount(cart_list.length);
      Utils.prinAppMessages(value.toString());
      setLoadingBasket(false);
      getDefaultAddress(ctx!);
    }).onError((error, stackTrace) {
      setLoadingBasket(false);
      changeCartCount(cart_list.length);
      getDefaultAddress(ctx!);

      Utils.showFlushbarError(error.toString(), ctx!);
      Utils.prinAppMessages(error.toString());
    });
  }


  var whish_list = [];
  bool _loading_whishlist = false;
  bool get loading_whishlist => _loading_whishlist;

  setLoadingWhishlist(bool value) {
    _loading_whishlist = value;
    notifyListeners();
  }
  Future<void> getWhishList() async {
    whish_list.clear();
    setLoadingWhishlist(true);
    await _repoProduct.getWishList().then((value) {
      whish_list.clear();

      if (value['error'] == 1) {
        whish_list.addAll(value['data']);
      }

      changeWhishlistCount(whish_list.length);
      Utils.prinAppMessages(value.toString());
      setLoadingWhishlist(false);

    }).onError((error, stackTrace) {
      setLoadingWhishlist(false);
      changeWhishlistCount(whish_list.length);


      Utils.showFlushbarError(error.toString(), ctx!);
      Utils.prinAppMessages(error.toString());
    });
  }

  void changeSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  getLocation() {
    if (default_address == null || ((default_address is List)?(default_address as List).isEmpty:default_address==null)) {
      return "Not Selected";
    } else {
      return "${default_address['landmark'] == null ? '' : default_address['landmark'] + ","} ${default_address['city']}, ${default_address['state']}";
    }
  }
}
