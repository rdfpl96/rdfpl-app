import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../repositories/product_repository.dart';
import '../utils/Utils.dart';
import '../utils/routes/routes_name.dart';
import 'home_viewmodel.dart';

class OfferViewModel with ChangeNotifier{
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,);

  bool isFinish = false;

  RefreshController get refreshController => _refreshController;
  int _currentPage = 1;
  int _RecordsPerPage = 10;
  final _repo = ProductRepository();
  bool _loading = false;


  var data_list = [];

  bool get loading => _loading;

  int get currentPage => _currentPage;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  bool _loading_add_to_cart = false;

  bool get loading_add_to_cart => _loading_add_to_cart;

  setLoadingAddToCart(bool value) {
    _loading_add_to_cart = value;
    notifyListeners();
  }

  late BuildContext ctx;
  HomeViewModel? homeViewModel;

  OfferViewModel(BuildContext context, HomeViewModel homeViewModel) {
    ctx = context;
    this.homeViewModel = homeViewModel;
  }

  String search = "";
  String short_by = "",
      filterbyPrice = "",
      cat_filter = "";


  void serachProduct(String search, int page, BuildContext context) async {
    this.search = search;
    print(
        'Page :$page --------------------------------------------------------------------------');
    if (page != null && page == 1) {
      _currentPage = page;
    }
    if (_currentPage == 1) {
      data_list = [];
    }
    // {"page":"1","top_cat_id":1,"sub_id":2,"child_cat_id":20}
    //cat_id=1;sub_cat_id=2;child_cat_id=20;

    // Map<String,dynamic> data={
    //   "page":_currentPage,
    //   "top_cat_id":"",
    //   "sub_id":"",
    //   "child_cat_id":"",
    //   "search_key":search
    // };

    print(
        "Filters on product: cat_filter=$cat_filter price_filter=$filterbyPrice sortBy=$short_by");
    Map<String, dynamic> data = {
      "page": _currentPage,
      "top_cat_id": (cat_filter != null && cat_filter != "") ? cat_filter : "",
      "sub_id": "",
      "child_cat_id": "",
      "search_key": search,
      "short_by": short_by == null ? "" : short_by,
      "filterbyPrice": filterbyPrice == null ? "" : filterbyPrice
    };
    // String params="limit_per_page=$_RecordsPerPage&current_page=$_currentPage${cat_id>0?'&category_id=$cat_id':''}${sub_cat_id>0?'&sub_category_id=$sub_cat_id':''}${child_cat_id>0?'&child_category_id=$child_cat_id':''}";
    Utils.prinAppMessages(data);
    setLoading(true);
    await _repo.getProduct(jsonEncode(data)).then((value) {
      if (_currentPage == 1) {
        _refreshController.refreshCompleted();
      } else {
        _refreshController.loadComplete();
      }
      setLoading(false);
      if (value == null) {
        isFinish = true;
      }
      else if (value['error'] == 0) {
        List _newList = value['data']['products'] as List;
        for (int x = 0; x < _newList.length; x++) {
          for (int z = 0; z < (_newList[x]['items'] as List).length; z++) {
            _newList[x]['items'][z]['is_selected'] = (z == 0 ? true : false);
          }
        }
        data_list.addAll(_newList);
        checkForCartQty();

        if (data_list.length > 0) {
          Utils.prinAppMessages("Total Data Length=${data_list
              .length}\nRecordsPerPage=$_RecordsPerPage\nCondition=${data_list
              .length % _RecordsPerPage != 0}");
          if (data_list.length % _RecordsPerPage != 0) {
            isFinish = true;
          }
        }
      } else if (value['status'] == 403) {
        Utils.showFlushbarError(value['error'] != null
            ? value['error'].toString()
            : 'Invalid Access', context);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.route_login_signup, (route) => false);
      }

      Utils.prinAppMessages(value.toString());
    }).onError((error, stackTrace) {
      if (_currentPage == 1) {
        _refreshController.refreshFailed();
      } else {
        _refreshController.loadFailed();
      }
      setLoading(false);
      Utils.showFlushbarError('An Error Occured', context);
      Utils.prinAppMessages(error.toString());
    });

    // var data=jsonEncode({
    //   "getKeywords": search
    // });
    // Utils.prinAppMessages(data);
    // data_list.clear();
    // setLoading(true);
    // _repo.searchProduct(data).then((value) {
    //
    //   Utils.showFlushbarError(value['message'],context);
    //
    //   if(value['status']==200) {
    //     data_list=value['response'];
    //
    //   }else{
    //     Utils.showFlushbarError('${value['message']}', context);
    //   }
    //
    //   Utils.prinAppMessages(value.toString());
    //   setLoading(false);
    // }).onError((error, stackTrace) {
    //   setLoading(false);
    //   Utils.showFlushbarError(error.toString(),context);
    //   Utils.prinAppMessages(error.toString());
    // });
  }

  onRefresh(BuildContext context) {
    data_list.clear();
    _currentPage = 1;
    if (loading == true) {
      return true;
    }
    serachProduct(search, 1, context);
  }

  Future<bool> loadMoreData() async {
    // await Future.delayed(const Duration(seconds: 3, milliseconds: 100));
    // if(true){return Future(() => true);}
    if (loading == true) {
      return Future(() => true);
    }
    setLoading(true);
    _currentPage++;

    serachProduct(search, _currentPage, ctx);

    return Future(() => true);
  }

  var PRODUCT_DET;

  void addToCart(int index, String type, BuildContext context) async {
    if (_loading_add_to_cart) {
      return;
    }
    var product_det = data_list[index];
    PRODUCT_DET = product_det;

    var selected_item = getSelected(index);
    int prod_qty = selected_item['qty'] == null ? 0 : int.parse(
        selected_item['qty'].toString());

    // if(prod_qty==1 && type=='-'){
    //   await deleteFromCart(selected_item,index,context);
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
    _repo.addToCart(jsonEncode(raw_data)).then((value) {
      if (value['error'] == 0) {
        // var _items=value['response'] as List;
        // for(int x=0;x<_items.length;x++){
        //
        //   if(_items[x]['product_id']==product_det['product_id'] && _items[x]['variant_id']==selected_item['variant_id']){
        //     for(int a=0;a<(data_list[index]['variants']as List).length;a++){
        //       if(data_list[index]['variants'][a]['variant_id']==selected_item['variant_id']){
        //         data_list[index]['variants'][a]['qty']=_items[x]['qty'];
        //         data_list[index]['variants'][a]['cart_id']=_items[x]['cart_id'];
        //         break;
        //       }
        //     }
        //    // data_list[index]['qty']=_items[x]['qty'];
        //
        //   }
        // }
        for (int a = 0; a < (data_list[index]['items'] as List).length; a++) {
          if (data_list[index]['items'][a]['variant_id'] ==
              selected_item['variant_id']) {
            data_list[index]['items'][a]['qty'] = prod_qty;
            break;
          }
        }
        updateBadge(0, null);
      } else {
        Utils.showFlushbarError(value['msg'], context);
      }
      Utils.prinAppMessages(value.toString());
      setLoadingAddToCart(false);
    }).onError((error, stackTrace) {
      print("Add Cardt Error $stackTrace");
      setLoadingAddToCart(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  void updateBadge(int count, type) async {
    // HomeViewModel home=Provider.of(ctx,listen: false);
    await homeViewModel!.getBasketList();
    // if(type!=null && type=='del'){
    //   home.changeCartCount(home.cart_count-1);
    // }else {
    //   home.changeCartCount(count);
    // }
  }

  getSelected(int index) {
    for (int i = 0; i < (data_list[index]['items'] as List).length; i++) {
      if (data_list[index]['items'][i]['is_selected'] == true) {
        return data_list[index]['items'][i];
      }
    }
  }

  void setSelectedVarient(index, val) {
    for (int x = 0; x < (data_list[index]['items'] as List)
        .length; x++) {
      bool is_selected = false;
      if (data_list[index]['items'][x]['variant_id'] == val['variant_id']) {
        is_selected = true;
      }
      data_list[index]['items'][x]['is_selected'] = is_selected;
    }
    notifyListeners();
  }

  void checkForCartQty() {
    // HomeViewModel homeViewModel=Provider.of(ctx,listen: false);
    //
    homeViewModel!.cart_list.forEach((cart_item) {
      if (cart_item != null) {
        for (int i = 0; i < data_list.length; i++) {
          if (cart_item['product_id'] == data_list[i]['product_id']) {
            for (int j = 0; j < (data_list[i]['items'] as List).length; j++) {
              if (cart_item['variant_id'] ==
                  data_list[i]['items'][j]['variant_id']) {
                data_list[i]['items'][j]['qty'] = cart_item['cart_qty'];
              }
            }
          }
        }
      }
    });
    notifyListeners();
  }

  void filterProducts(String _search,BuildContext context) {
    print('filtering data......$_search ');
    serachProduct(_search,1,context);
  }
}