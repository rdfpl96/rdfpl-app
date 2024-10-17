import 'dart:convert';

// import 'package:royal_dry_fruit/main_screen.dart';
import 'package:royal_dry_fruit/repositories/auth_repository.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/view_models/home_viewmodel.dart';
import 'package:royal_dry_fruit/view_models/product_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateUserDetailViewModel with ChangeNotifier {
  final _authRepo = AuthRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> updateuserdetails(var raw_data, BuildContext context) async {


    Utils.prinAppMessages(raw_data);
    setLoading(true);
    _authRepo.updateuserdetails(jsonEncode(raw_data)).then((value) {
      setLoading(false);


      if (value['error'] == 0) {
        Utils.showFlushbarError(value['msg'], context,false);
        if(raw_data["field_type"]!="1") {
          Future.delayed(
            Duration(seconds: 1),
                () {
              var _send_data = raw_data['field_type']=='3' ? {
                "mobile": raw_data['mobile']
              } : {"email": raw_data['email']};
              print('reverify data:$_send_data');
              Navigator.pushNamed(context, RouteNames.route_re_verify_screen,
                  arguments: _send_data);
            },
          );
        }
      }else{
        Utils.showFlushbarError(value['msg'], context);
      }
      Utils.prinAppMessages(value.toString());
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }
}
