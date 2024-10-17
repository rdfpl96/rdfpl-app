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

class ProductDetViewModel with ChangeNotifier {
  final _repo = ProductRepository();
  bool _loading = false;
  bool _loading_in_details = false;
  bool _loading_add_to_cart = false;

  var product_detail;
  var images_list=[];
  var list_rating_review;

  var Prod_Rating="0";

  bool get loading => _loading;

  bool get loading_in_details => _loading_in_details;

  bool get loading_add_to_cart => _loading_add_to_cart;

  setLoadingAddToCart(bool value) {
    _loading_add_to_cart = value;
    notifyListeners();
  }

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setLoadingInDetails(bool loading) {
    _loading_in_details = loading;
    notifyListeners();
  }

  late BuildContext ctx;
  HomeViewModel? homeViewModel;

  ProductDetViewModel(HomeViewModel homeViewModel, BuildContext context) {
    ctx = context;
    this.homeViewModel = homeViewModel;
  }

  var _selected_varient;

  get selected_varient => _selected_varient;

  void setSelectedVarient(val) {
    _selected_varient = val;
    notifyListeners();
  }

  dynamic getSelected() {
    return _selected_varient;
  }

  String getPercentage(){
    double before_off=double.parse(selected_varient['before_off_price'].toString());
    if(before_off==0){
      return "";
    }else{
      double price=double.parse(selected_varient['price'].toString());
      Utils.prinAppMessages("Total Discount :${before_off-price} selling price:$price  before discount:$before_off");

      double res=((before_off-price)/before_off)*100;
      return res.toStringAsPrecision(3);
    }
  }

  String? _selected_img;

  String? get selected_img => _selected_img;

  void setSelectedImage(String image){
    _selected_img=image;
    notifyListeners();
  }

  void getProductDetails(var model, BuildContext context) {
    // setLoading(true);
    // product_detail=[model];
    // if(selected_varient==null){
    //   setSelectedVarient(product_detail[0]['items'][0]);
    // }
    // setLoading(false);
    String params = "/${model['product_id']}/1/1/1";

    setLoading(true);
    _repo.getProductDetails(params).then((value) {

      if (value['error'] == 0) {
        product_detail = value['data']['pdetail'];
        isInWhishList=product_detail['is_wishlist'];
        list_rating_review = value['data']['ratingReview'];

        if (_selected_varient == null) {
          setSelectedVarient(product_detail['items'][0]);
        }
        if(product_detail['image1']!=null && product_detail['image1']!='') {
          images_list.add("${product_detail['image1']}");
        }
        if(product_detail['image2']!=null && product_detail['image2']!='') {
          images_list.add("${product_detail['image2']}");
        }
        if(product_detail['image3']!=null && product_detail['image3']!='') {
          images_list.add("${product_detail['image3']}");
        }
        if(product_detail['image4']!=null && product_detail['image4']!='') {
          images_list.add("${product_detail['image4']}");
        }
        if(product_detail['image5']!=null && product_detail['image5']!='') {
          images_list.add("${product_detail['image5']}");
        }
        if(images_list!=null && images_list.isNotEmpty) {
          _selected_img = images_list[0];
        }
        try{Prod_Rating=value['data']['average_rating'].toString();}catch(E){}
      }
      checkCartQty();
      Utils.prinAppMessages(value.toString());
      setLoading(false);

    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  int cart_count = 0;

  void updateBadge(int count, type) async {
    await homeViewModel!.getBasketList();
    cart_count = homeViewModel!.cart_count;
    notifyListeners();
    // if(type!=null && type=='del'){
    //   homeViewModel!.changeCartCount(homeViewModel!.cart_count-1);
    // }else {
    //   homeViewModel!.changeCartCount(count);
    // }
  }
  void updateWhishlist() async {
    await homeViewModel!.getWhishList();
    notifyListeners();
    // if(type!=null && type=='del'){
    //   homeViewModel!.changeCartCount(homeViewModel!.cart_count-1);
    // }else {
    //   homeViewModel!.changeCartCount(count);
    // }
  }

  void addToCart(var product_det, String type, BuildContext context) async {
    if (_loading_add_to_cart) {
      return;
    }

    int prod_qty = _selected_varient['qty'] == null
        ? 0
        : int.parse(_selected_varient['qty'].toString());

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
      "variant_id": _selected_varient['variant_id'],
      "qty": _qty,
      "action_type": "2"
    };

    Utils.prinAppMessages(raw_data);
    setLoadingAddToCart(true);
    _repo.addToCart(jsonEncode(raw_data)).then((value) {

      if (value['error'] == 0) {
        print("Product ID: ${product_detail['product_id']}");
        for (int i = 0; i < (product_detail['items'] as List).length; i++) {
          if (product_detail['items'][i]['variant_id'] ==
              _selected_varient['variant_id']) {
            product_detail['items'][i]['qty'] = "$prod_qty";
          }
        }
        updateBadge(0, null);
      }else{
        Utils.showFlushbarError(value['msg'], context);
      }
      Utils.prinAppMessages(value.toString());
      setLoadingAddToCart(false);
    }).onError((error, stackTrace) {
      setLoadingAddToCart(false);
      print(error);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  //----------------------------------------------------------------------------------------------------------------
  //-Whishlist-------------------------------------------------------------------------
  //----------------------------------------------------------------------------------------------------------------

  bool isInWhishList = false;

  setWhishList() {
    isInWhishList = true;
    notifyListeners();
  }

  bool _loading_whishlist = false;

  get loading_whishlist => _loading_whishlist;

  setLoadingWhishList(bool val) {
    _loading_whishlist = val;
    notifyListeners();
  }

  Future<void> addToWishList(var model, BuildContext context) async {
    if(isInWhishList==true){
      deleteFromWhishlist(context, model);
      return;
    }
    if (_loading_whishlist) {
      return;
    }

    var _data = {"product_id": product_detail['product_id']};

    Utils.prinAppMessages(_data);
    setLoadingWhishList(true);
    _repo.addToWhishList(jsonEncode(_data)).then((value) {

      if (value['error'] == 0) {
        setWhishList();
        updateWhishlist();
      } else {
        Utils.showFlushbarError(value['msg'], context);
      }
      Utils.prinAppMessages(value.toString());
      setLoadingWhishList(false);
    }).onError((error, stackTrace) {
      print(stackTrace);
      setLoadingWhishList(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  searchProduct(BuildContext context) {
    Navigator.pushNamed(
        context, RouteNames.route_search_screen,
        arguments: [homeViewModel]);
  }

  void checkCartQty()async {
    List _cart_list=homeViewModel!.cart_list;
    for(int i=0;i<_cart_list.length;i++){
      if(_cart_list[i]['product_id']==product_detail['product_id']){
        for(int x=0;x<(product_detail['items']as List).length;x++) {
          if (_cart_list[i]['variant_id'] ==
              product_detail['items'][x]['variant_id']) {
            product_detail['items'][x]['qty']=_cart_list[i]['cart_qty'];
          }
        }

      }
    }
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
    _repo.deleteWhishlist(raw_data).then((value) {

      if(value['error']==0) {
        isInWhishList=false;
        product_detail['is_wishlist']=false;
        updateWhishlist();

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


//----------------------------------------------------------------------------------------------------------------
//-Whishlist-------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------

/* //----------------------------------------------------------------------------------------------------------------
  //-Product Rating-------------------------------------------------------------------------
  //----------------------------------------------------------------------------------------------------------------
  bool _is_loading_rating=false;
  get is_loading_rating=>_is_loading_rating;
  var list_rating_review;

  void setProductRatingLoading(bool loading){
    _is_loading_rating=loading;
    notifyListeners();
  }

  void getProductRating(var id,BuildContext context) async{

    SessionManager sessionManager=SessionManager();
    String? userId=await sessionManager.getString(SessionManager.KEY_UserId);
    var _data="?product_id=$id";

    Utils.prinAppMessages(_data);
    setProductRatingLoading(true);
    _repo.getProductRating(_data).then((value) {



      if(value['status']==200) {
        list_rating_review=value['response'];
      }else{
        Utils.showFlushbarError(value['message'],context);
      }
      Utils.prinAppMessages(value.toString());
      setProductRatingLoading(false);
    }).onError((error, stackTrace) {
      setProductRatingLoading(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });
  }


//----------------------------------------------------------------------------------------------------------------
//-Product Rating-------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------
*/
}
