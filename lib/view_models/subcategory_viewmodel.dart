import 'dart:convert';

import 'package:flutter/material.dart';

import '../repositories/product_repository.dart';
import '../utils/Utils.dart';
import '../utils/routes/routes_name.dart';
import '../utils/session_manager.dart';
import 'category_viewmodel.dart';
import 'home_viewmodel.dart';

class SubCategoryViewModel with ChangeNotifier{
  BuildContext context;
  var data;
  CategoryViewModel subcatViewModel;
  HomeViewModel homeViewModel;
  SubCategoryViewModel(this.context,this.data,this.subcatViewModel,this.homeViewModel){
    getProduct(context);
  }

  int _currentPage=1;
  int _RecordsPerPage=40;
  final _repo=ProductRepository();
  bool _loading=false;


  var data_list=[];


  bool get loading=>_loading;

  setLoading(bool loading){
    _loading=loading;
    notifyListeners();
  }

  bool _loading_add_to_cart=false;
  bool get loading_add_to_cart => _loading_add_to_cart;

  setLoadingAddToCart(bool value) {
    _loading_add_to_cart = value;
    notifyListeners();
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

  void getProduct( BuildContext context)async {
    if(_currentPage==1){
      data_list=[];
    }

    Map<String,dynamic> raw_data={
      "page":_currentPage,
      "top_cat_id":data['cat_id']==0?"":data['cat_id'],
      "sub_id":"",
      "child_cat_id":""
    };
    Utils.prinAppMessages(raw_data);
    setLoading(true);
    await _repo.getProduct(jsonEncode(raw_data)).then((value) {

      setLoading(false);
      if(value['error']==0) {
        List _newList=value['data']['products']as List;
        for (int x = 0; x < _newList.length;x++) {
          for(int z=0;z<(_newList[x]['items']as List).length;z++){
            _newList[x]['items'][z]['is_selected']=(z==0?true:false);
          }
        }
        data_list.addAll(_newList);
        checkForCartQty();

      }else if(value['error']==403){
        Utils.showFlushbarError(value['error']!=null?value['error'].toString():'Invalid Access',context);
        Navigator.pushNamedAndRemoveUntil(context, RouteNames.route_login_signup, (route) => false);
      }

      Utils.prinAppMessages(value.toString());

    }).onError((error, stackTrace) {

      setLoading(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });
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
      }
      Utils.prinAppMessages(value.toString());
      setLoadingAddToCart(false);
      homeViewModel.getBasketList();

    }).onError((error, stackTrace) {
      print(stackTrace);
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
  void checkForCartQty() {
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
  void onCategoryClick(cat_id) {

  }
}