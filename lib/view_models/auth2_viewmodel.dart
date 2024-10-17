import 'dart:async';
import 'dart:convert';

import 'package:royal_dry_fruit/repositories/auth_repository.dart';
import 'package:royal_dry_fruit/utils/AppUtils.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/utils/session_manager.dart';
import 'package:flutter/material.dart';

import '../views/update_profile_screen.dart';

class Auth2ViewModel with ChangeNotifier {
  Auth2ViewModel() {
    Status_bar();
    startTimer();
  }
  final _authRepo = AuthRepository();


  bool _loading = false;
  bool _isemail_login = false;
  bool get isemail_login => _isemail_login;
  bool get loading => _loading;
  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }
  setEmailLogin(bool isemail_login) {
    _isemail_login = isemail_login;
    notifyListeners();
  }

  // Validations
  final RegExp _emailRegExp = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );

  bool _validateEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  final RegExp _mobileNumberRegExp = RegExp(
    r'^\d{10}$',
  );

  bool _validateMobileNumber(String mobileNumber) {
    return _mobileNumberRegExp.hasMatch(mobileNumber);
  }
  //Validations


  void verifyotp(Map data, BuildContext context) {
    Utils.prinAppMessages(data);
    setLoading(true);
    if (data['mobile'] == null || data['mobile'] == '') {
      _authRepo.verifyotp_email(jsonEncode(data),true).then((value) {
        setLoading(false);

        if (value['error'] == 0) {
          afterLogin(context, value);
        } else {
          Utils.showFlushbarError(value['msg'], context);
        }
        Utils.prinAppMessages(value.toString());
      }).onError((error, stackTrace) {
        setLoading(false);
        Utils.showFlushbarError(error.toString(), context);
        Utils.prinAppMessages(error.toString());
      });
    } else {
      _authRepo.verifyotp(jsonEncode(data),true).then((value) {
        setLoading(false);

        if (value['error'] == 0) {
          afterLogin(context, value);
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
  }

  //Section for loading Resend
  bool _loading_resend = false;
  bool get loading_resend => _loading_resend;
  setLoadingResend(bool loading) {
    _loading_resend = loading;
    notifyListeners();
  }

  void reSendOtp(Map data, BuildContext context) {
    Utils.prinAppMessages(data);
    setLoadingResend(true);
    if (data['mobile'] == null || data['mobile'] == '') {
      _authRepo.resendOtpEmail(jsonEncode(data)).then((value) {
        setLoadingResend(false);
        if (value['error'] == 0) {
          Utils.showFlushbarError(value['msg'], context, false);
        } else {
          Utils.showFlushbarError(value['msg'], context);
        }
        Utils.prinAppMessages(value.toString());
      }).onError((error, stackTrace) {
        setLoadingResend(false);
        Utils.showFlushbarError(error.toString(), context);
        Utils.prinAppMessages(error.toString());
      });
    } else {
      _authRepo.resendOtpMobile(jsonEncode(data)).then((value) {
        setLoadingResend(false);

        if (value['error'] == 0) {
          Utils.showFlushbarError(value['msg'], context, false);
        } else {
          Utils.showFlushbarError(value['msg'], context);
        }
        Utils.prinAppMessages(value.toString());
      }).onError((error, stackTrace) {
        setLoadingResend(false);
        Utils.showFlushbarError(error.toString(), context);
        Utils.prinAppMessages(error.toString());
      });
    }
  }

  //Section for loading Resend

  void afterLogin(BuildContext context, var value) {
    SessionManager sessionManager = new SessionManager();
    sessionManager.storeUserDetails(
        "-1",
        value['userDetail']['detail']['name'] == null
            ? ""
            : value['userDetail']['detail']['name'],
        value['userDetail']['detail']['lname']==null?"":value['userDetail']['detail']['lname'],
        value['userDetail']['detail']['email'] == null
            ? ""
            : value['userDetail']['detail']['email'],
        value['userDetail']['detail']['mobile'] == null
            ? ""
            : value['userDetail']['detail']['mobile'].toString(),
        value['userDetail']['token'] == null
            ? ""
            : value['userDetail']['token']);

    if (value['userDetail']['detail']['email'] != null &&
        value['userDetail']['detail']['email'] != '' &&
        value['userDetail']['detail']['mobile'] != null &&
        value['userDetail']['detail']['mobile'].toString() != "") {
      //skip update part
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.route_home,(Route<dynamic> route) => false);

    } else {
      Navigator.pushNamed(context, RouteNames.route_update_profile_details,
          arguments: [value['userDetail']['detail'],VIEW_TYPE.UPDATE]);
    }
  }




  //resend otp timmer
  int _timeRemaining = 30;
  bool _isButtonVisible = false;
  late Timer _timer;

  int get timeRemaining => _timeRemaining;
  bool get isButtonVisible => _isButtonVisible;



  void startTimer() {
    _timeRemaining = 30;
    _isButtonVisible = false;
    notifyListeners();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        _timeRemaining--;
      } else {
        _isButtonVisible = true;
        _timer.cancel();
      }
      notifyListeners();
    });
  }

  void resetTimer() {
    _timer.cancel();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
