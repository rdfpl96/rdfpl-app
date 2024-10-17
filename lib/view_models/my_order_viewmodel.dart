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

class MyOrderViewModel with ChangeNotifier{
  RefreshController _refreshController = RefreshController(initialRefresh: false);



  RefreshController get refreshController => _refreshController;
  int _currentPage=1;
  int _RecordsPerPage=10;
  final _repo=ProductRepository();
  bool _loading=false;


  var data_list=[];


  bool get loading=>_loading;


  get loadMoreData1 => loadMoreData();
  setLoading(bool loading){
    _loading=loading;
    notifyListeners();
  }


  late BuildContext ctx;

  MyOrderViewModel(BuildContext context){
    ctx=context;
    _currentPage=1;
    Utils.prinAppMessages('Current Page:$_currentPage');
    getData(context);
  }

  bool isFinish=false;



  void getData( BuildContext context)async {
    if(_currentPage==1){
      data_list=[];
    }
    String params="?cust_id=${(await  SessionManager().getString(SessionManager.KEY_UserId))!}&limit_per_page=$_RecordsPerPage&current_page=$_currentPage";
    Utils.prinAppMessages(params);
    setLoading(true);
    await _repo.orderHistory(params).then((value) {
      if(_currentPage==1){
        _refreshController.refreshCompleted();
        data_list.clear();

      }else {
        _refreshController.loadComplete();
      }
        setLoading(false);
        if(value==null){
          isFinish=true;
        }
        else if(value['error']==0) {
          List _newList=value['data']['order']as List;

          data_list.addAll(_newList);

          if(data_list.length>0){
            Utils.prinAppMessages("Total Data Length=${data_list.length}\nRecordsPerPage=$_RecordsPerPage\nCondition=${data_list.length%_RecordsPerPage!=0}");
            if(data_list.length%_RecordsPerPage!=0){
              isFinish=true;
            }
          }
        }else if(value['status']==403){
          Utils.showFlushbarError(value['error']!=null?value['error'].toString():'Invalid Access',context);
          Navigator.pushNamedAndRemoveUntil(context, RouteNames.route_login_signup, (route) => false);
        }else{
          Utils.showFlushbarError(value['msg'],context);
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



Future<bool> loadMoreData()async {
  // await Future.delayed(const Duration(seconds: 3, milliseconds: 100));
   // if(true){return Future(() => true);}
  if(loading==true){return Future(() => true);}
  setLoading(true);
  _currentPage++;

  getData(ctx);

  return Future(() => true);
  }

  onRefresh(BuildContext context) {
    data_list.clear();
    _currentPage=1;
    if(loading==true){return true;}
    getData(context);

  }

  onOrderClick(data_list) {
    Navigator.pushNamed(ctx, RouteNames.route_order_details,arguments: data_list);
  }

  String getOrderDate(int index) {
    List<String> dt=data_list[index]['order_date'].toString().split(" ");
    return dt[0];
  }

}