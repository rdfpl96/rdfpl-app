import 'package:flutter/material.dart';

import '../repositories/product_repository.dart';
import '../utils/Utils.dart';

class MyReviewsViewModel with ChangeNotifier{

  final _repo=ProductRepository();

  //Loading Sections
  bool _loading=false;
  bool get loading=>_loading;

  setLoading(bool loading){
    _loading=loading;
    notifyListeners();
  }

  //Loading Sections End

  var data_list=[];





  late BuildContext ctx;

  MyReviewsViewModel(BuildContext context){
    ctx=context;

    getData(context);
  }




  void getData( BuildContext context)async {

    setLoading(true);
    await _repo.getMyRatings().then((value) {
      data_list=[];
      setLoading(false);

      if(value['error']==0) {
        data_list.addAll(value['data']);
      }else{
        Utils.showFlushbarError(value['msg'],context);
      }

      Utils.prinAppMessages(value.toString());

    }).onError((error, stackTrace) {

      setLoading(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });
  }
}