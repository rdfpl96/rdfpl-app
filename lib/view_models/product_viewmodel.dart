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

class ProductViewModel with ChangeNotifier{
  RefreshController _refreshController = RefreshController(initialRefresh: false,);


  RefreshController get refreshController => _refreshController;
  int _currentPage=1;
  int _RecordsPerPage=10;
  final _repo=ProductRepository();
  bool _loading=false;


  var data_list=[];
 int get currentPage => _currentPage;

  bool get loading=>_loading;
  bool _loading_add_to_cart=false;
  bool get loading_add_to_cart => _loading_add_to_cart;

  setLoadingAddToCart(bool value) {
    _loading_add_to_cart = value;
    notifyListeners();
  }

  // get loadMoreData1 => loadMoreData();
  setLoading(bool loading){
    _loading=loading;
    notifyListeners();
  }

  bool _loading_delete_from_cart=false;

  bool get loading_delete_from_cart => _loading_delete_from_cart;
  void setLoadingDeleteFromCart(bool loading){
    _loading_delete_from_cart=loading;
    notifyListeners();
  }

  late BuildContext ctx;
  // late HomeViewModel homeViewModel;
  ProductViewModel(BuildContext context){
    ctx=context;
    // homeViewModel=Provider.of(ctx);
    _currentPage=1;
    data_list=[];
    Utils.prinAppMessages('Current Page:$_currentPage');
  }

  bool isFinish=false;


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

  String short_by="", filterbyPrice="",cat_filter="";


  Future<void> getProduct( BuildContext context,int cat_id,int sub_cat_id,int child_cat_id,[int? page])async {
    setLoading(true);
    print('Page :$page --------------------------------------------------------------------------');
    if(page!=null && page==1){
      _currentPage=page;
    }
    if(_currentPage==1){
      data_list=[];
    }
    // {"page":"1","top_cat_id":1,"sub_id":2,"child_cat_id":20}
    //cat_id=1;sub_cat_id=2;child_cat_id=20;


  print("Filters on product: cat_filter=$cat_filter price_filter=$filterbyPrice sortBy=$short_by");
    Map<String,dynamic> data={
      "page":_currentPage,
      "top_cat_id":(cat_filter!=null && cat_filter!="")?cat_filter:(cat_id==0?"":cat_id),
      "sub_id":sub_cat_id==0?"":sub_cat_id,
      "child_cat_id":child_cat_id==0?"":child_cat_id,
      "search_key":"",
      "short_by":short_by==null?"":short_by,
      "filterbyPrice":filterbyPrice==null?"":filterbyPrice
    };
    print("Raw Product:$data");
    // String params="limit_per_page=$_RecordsPerPage&current_page=$_currentPage${cat_id>0?'&category_id=$cat_id':''}${sub_cat_id>0?'&sub_category_id=$sub_cat_id':''}${child_cat_id>0?'&child_category_id=$child_cat_id':''}";
    Utils.prinAppMessages(data);

    await _repo.getProduct(jsonEncode(data)).then((value) {
      setLoading(false);
      if(_currentPage==1){
        _refreshController.refreshCompleted();

      }else {
        _refreshController.loadComplete();
      }

        if(value==null){
          isFinish=true;
        }
        else if(value['error']==0) {
          List _newList=value['data']['products']as List;
          for (int x = 0; x < _newList.length;x++) {
            for(int z=0;z<(_newList[x]['items']as List).length;z++){
              _newList[x]['items'][z]['is_selected']=(z==0?true:false);
            }
          }
          data_list.addAll(_newList);
          checkForCartQty();

          if(data_list.length>0){
            Utils.prinAppMessages("Total Data Length=${data_list.length}\nRecordsPerPage=$_RecordsPerPage\nCondition=${data_list.length%_RecordsPerPage!=0}");
            if(data_list.length%_RecordsPerPage!=0){
              isFinish=true;
            }
          }
        }else if(value['status']==403){
          Utils.showFlushbarError(value['error']!=null?value['error'].toString():'Invalid Access',context);
          Navigator.pushNamedAndRemoveUntil(context, RouteNames.route_login_signup, (route) => false);
        }

        Utils.prinAppMessages(value.toString());

    }).onError((error, stackTrace) {
      if(_currentPage==1){
        _refreshController.refreshFailed();

      }else {
        _refreshController.loadFailed();
      }
      setLoading(false);
      Utils.showFlushbarError('An Error Occured',context);
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

    // if(prod_qty==1 && type=='-'){
    //   await deleteFromCart(selected_item,index,context);
    //
    //   return;
    //
    // }
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

  Future<void> deleteFromCart(var selected_item,int index,BuildContext context) async{
    if(_loading_delete_from_cart){
      return;
    }
    int CART_ID=selected_item['cart_id']==null?0:int.parse(selected_item['cart_id']);
    SessionManager sessionManager=SessionManager();
    String? userId=await sessionManager.getString(SessionManager.KEY_UserId);
    var _data={
      "customer_id":userId,
      "cart_id":CART_ID
    };

    Utils.prinAppMessages(_data);
    setLoadingDeleteFromCart(true);
    _repo.deleteFromCart(jsonEncode(_data)).then((value) {

      if(value['status']==200) {

        for(int a=0;a<(data_list[index]['variants']as List).length;a++){
          if(data_list[index]['variants'][a]['variant_id']==selected_item['variant_id']){
            data_list[index]['variants'][a]['qty']=0;
            data_list[index]['variants'][a]['cart_id']=0;
            updateBadge(0, 'del');
            break;
          }
        }



      }else{
        Utils.showFlushbarError(value['message'], context);

      }
      Utils.prinAppMessages(value.toString());
      setLoadingDeleteFromCart(false);
    }).onError((error, stackTrace) {
      print(stackTrace);
      setLoadingDeleteFromCart(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });
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
    Future<bool> loadMoreData(int cat_id,int sub_cat_id,int child_cat_id)async {
  // await Future.delayed(const Duration(seconds: 3, milliseconds: 100));
   // if(true){return Future(() => true);}
  if(loading==true){return Future(() => true);}
  setLoading(true);
  _currentPage++;

  getProduct(ctx,cat_id,sub_cat_id,child_cat_id);

  return Future(() => true);
  }

  onRefresh(BuildContext context,int cat_id,sub_cat_id,child_cat_id) {
    data_list.clear();
    _currentPage=1;
    if(loading==true){return true;}
    getProduct(context,cat_id,sub_cat_id,child_cat_id);

  }

  getSelected(int index) {
      for(int i=0;i<(data_list[index]['items']as List).length;i++){
        if(data_list[index]['items'][i]['is_selected']==true){
           return data_list[index]['items'][i];
        }
      }
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

  void filterProducts(BuildContext context,int cat_id,int sub_cat_id,int child_cat_id,) {
    getProduct(context, cat_id, sub_cat_id, child_cat_id,1);
  }
}