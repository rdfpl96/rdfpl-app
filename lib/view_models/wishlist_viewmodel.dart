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

class WishListViewModel with ChangeNotifier{
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  RefreshController get refreshController => _refreshController;
  int _currentPage=1;
  int _RecordsPerPage=10;

  final _repo=ProductRepository();
  bool _loading=false;
  var data_list=[];


  bool get loading=>_loading;

  setLoading(bool loading){
    _loading=loading;
    notifyListeners();
  }


  late BuildContext ctx;
  WishListViewModel(BuildContext context){
    ctx=context;
    _currentPage=1;
    Utils.prinAppMessages('Current Page:$_currentPage');
  }

  bool isFinish=false;


  void getWishList( BuildContext context)async {
    if(_currentPage==1){
      data_list=[];
    }
    SessionManager sessionManager=SessionManager();

    setLoading(true);
    await _repo.getWishList().then((value) {
      if(_currentPage==1){
        _refreshController.refreshCompleted();

      }else {
        _refreshController.loadComplete();
      }
        setLoading(false);
        if(value==null){
          isFinish=true;
        }
        else if(value['error']==1) {
          data_list.addAll(value['data']);
          for (int x = 0; x < data_list.length;x++) {
            for(int z=0;z<(data_list[x]['items']as List).length;z++){
              data_list[x]['items'][z]['is_selected']=(z==0?true:false);
            }
          }
          checkForCartQty();
          // if(data_list.length>0){
          //   Utils.prinAppMessages("Total Data Length=${data_list.length}\nRecordsPerPage=$_RecordsPerPage\nCondition=${data_list.length%_RecordsPerPage!=0}");
          //   if(data_list.length%_RecordsPerPage!=0){
          //     isFinish=true;
          //   }
          // }
        }

        Utils.prinAppMessages(value.toString());

    }).onError((error, stackTrace) {
      if(_currentPage==1){
        _refreshController.refreshFailed();

      }else {
        _refreshController.loadFailed();
      }
      setLoading(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });
  }

  bool _loading_add_to_cart=false;
  bool get loading_add_to_cart => _loading_add_to_cart;

  setLoadingAddToCart(bool value) {
    _loading_add_to_cart = value;
    notifyListeners();
  }

  var PRODUCT_DET;
  void addToCart(int index,String type,BuildContext context) async{
    if(_loading_add_to_cart){
      return;
    }
    var product_det=data_list[index];
    PRODUCT_DET=product_det;

    var selected_item=getSelected(index);
    int prod_qty=selected_item['qty']==null?0:int.parse(selected_item['qty'].toString());

    int _qty=0;
    if(type=='+'){
      _qty++;
      prod_qty++;
    }else{
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



      if(value['error']==0) {

        for(int a=0;a<(data_list[index]['items']as List).length;a++){
          if(data_list[index]['items'][a]['variant_id']==selected_item['variant_id']){
            data_list[index]['items'][a]['qty']=prod_qty;
            break;
          }
        }
        updateBadge(0,null);


      }
      Utils.prinAppMessages(value.toString());
      setLoadingAddToCart(false);
    }).onError((error, stackTrace) {
      print("Add Cardt Error $stackTrace");
      setLoadingAddToCart(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });
  }
  getSelected(int index) {
    for(int i=0;i<(data_list[index]['items']as List).length;i++){
      if(data_list[index]['items'][i]['is_selected']==true){
        return data_list[index]['items'][i];
      }
    }
  }
  void updateBadge(int count,type)async {
    HomeViewModel home=Provider.of(ctx,listen: false);
    await home.getBasketList();
    // if(type!=null && type=='del'){
    //   home.changeCartCount(home.cart_count-1);
    // }else {
    //   home.changeCartCount(count);
    // }
  }
  void setSelectedVarient(index,val){
    for (int x = 0; x < (data_list[index]['items'] as List)
        .length; x++) {
      bool is_selected=false;
      if(data_list[index]['items'][x]['variant_id']==val['variant_id']){
        is_selected=true;
      }
      data_list[index]['items'][x]['is_selected']=is_selected;
    }
    notifyListeners();
  }
  void checkForCartQty() {
    HomeViewModel homeViewModel=Provider.of(ctx,listen: false);

    homeViewModel.cart_list.forEach((cart_item) {
      if(cart_item!=null) {
        for (int i = 0; i < data_list.length; i++) {
          if (cart_item['product_id'] == data_list[i]['product_id']) {
            for (int j = 0; j < (data_list[i]['items'] as List).length; j++) {
              if (cart_item['variant_id'] == data_list[i]['items'][j]['variant_id']) {
                data_list[i]['items'][j]['qty'] = cart_item['cart_qty'];
              }
            }
          }
        }
      }
    });
    notifyListeners();

  }
  Future<bool> loadMoreData()async {
  // await Future.delayed(const Duration(seconds: 3, milliseconds: 100));
   // if(true){return Future(() => true);}
  if(loading==true){return Future(() => true);}
  setLoading(true);
  _currentPage++;

  getWishList(ctx);

  return Future(() => true);
  }

  onRefresh(BuildContext context) {
    data_list.clear();
    _currentPage=1;
    if(loading==true){return true;}
    getWishList(context);

  }


  bool _loading_delete_whishlist=false;
  bool get loading_delete_whishlist => _loading_delete_whishlist;

  setLoadingDeleteWhslist(bool value) {
    _loading_delete_whishlist = value;
    notifyListeners();
  }
  void deleteFromWhishlist(BuildContext context, dat) {
    if(_loading_delete_whishlist){
      return;
    }

    var raw_data = "/${dat['product_id']}";

    Utils.prinAppMessages(raw_data);
    setLoadingDeleteWhslist(true);
    _repo.deleteWhishlist(raw_data).then((value)async {

      if(value['error']==0) {
        for(int i=0;i<data_list.length;i++){
          if(data_list[i]['product_id']==dat['product_id']){
            data_list.removeAt(i);
          }
        }
        HomeViewModel home=Provider.of(ctx,listen: false);
        await home.getWhishList();
      }
      Utils.prinAppMessages(value.toString());
      setLoadingDeleteWhslist(false);
    }).onError((error, stackTrace) {
      print("Add Cardt Error $stackTrace");
      setLoadingDeleteWhslist(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });
  }
}