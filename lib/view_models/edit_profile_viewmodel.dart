import 'dart:convert';

import 'package:flutter/material.dart';

import '../repositories/auth_repository.dart';
import '../utils/Utils.dart';
import '../utils/routes/routes_name.dart';

class EditProfileViewModel with ChangeNotifier{
  final _authRepo = AuthRepository();
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  Future<void> updateuserdetails(dynamic data,var mainData, BuildContext context) async {
    Utils.prinAppMessages("data=$data");
    Utils.prinAppMessages("data=$mainData");
    var field_type="";
    if(mainData['email']==null){
      field_type="2";
    }
    else if(mainData['mobile']==null){
      field_type="3";
    }else if(mainData['name']==null){
      field_type="1";
    }
    //1- name,2-email,3-mobile
    var raw_data={
      "fname": data['name'],
      "lname": data['lname'],
      "email": mainData['email']==null?data['email']:mainData['email'],
      "mobile": mainData['mobile']==null?data['mobile']:mainData['mobile'],
      "field_type": field_type
    };

    Utils.prinAppMessages(raw_data);
    setLoading(true);
    _authRepo.updateuserdetails(jsonEncode(raw_data)).then((value) {
      setLoading(false);


      if (value['error'] == 0) {
        Utils.showFlushbarError(value['msg'], context,false);
        Future.delayed(
          Duration(seconds: 3),
              () {
            var _send_data=mainData['mobile']==null?{"mobile":data['mobile']}:{"email":data['email']};
            Navigator.pushNamed(context, RouteNames.route_re_verify_screen,arguments: _send_data);
          },
        );
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