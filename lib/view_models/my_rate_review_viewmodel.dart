import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';

import '../repositories/product_repository.dart';
import '../utils/Utils.dart';

class RateReviewsViewModel with ChangeNotifier {
  final _repo = ProductRepository();

  //Loading Sections
  bool _loading = false;

  TextEditingController tecReview = TextEditingController();

  bool get loading => _loading;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  //Loading Sections End



  late BuildContext ctx;
  var itm_details;

  RateReviewsViewModel(BuildContext context,var details) {
    ctx = context;
    itm_details = details;
  }

  void saveData(BuildContext context) async {
    if(ratings==0){
      Utils.showFlushbarError("Select Ratings", context);
      return;
    }
    if (tecReview.text == '') {
      Utils.showFlushbarError("Review Can Not Be Blank", context);
      return;
    }
    var data = {
      "product_id": itm_details['product_id'],
      "rate": ratings,
      "order_id": itm_details['order_id'],
      "comment": tecReview.text.toString()
    };
    setLoading(true);
    await _repo.giveRateAndReview(jsonEncode(data)).then((value) {

      setLoading(false);

      if (value['error'] == 0) {
        Navigator.pushNamed(context, RouteNames.route_after_review_screen,arguments: [""]);
      } else {
        Utils.showFlushbarError(value['msg'], context);
      }

      Utils.prinAppMessages(value.toString());
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  int _ratings = 0;

  int get ratings => _ratings;

  void setRatings(int index) {
    _ratings = index;
    notifyListeners();
  }
}
