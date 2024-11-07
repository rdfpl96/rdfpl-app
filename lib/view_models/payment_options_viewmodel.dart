import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:royal_dry_fruit/res/app_urls.dart';
import 'package:royal_dry_fruit/utils/CryptoUtils.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:weipl_checkout_flutter/weipl_checkout_flutter.dart';

import '../repositories/product_repository.dart';
import '../utils/Utils.dart';
import '../utils/session_manager.dart';

enum PAYMENT_OPTIONS { COD, ONLINE }

class PaymentOptionsViewModel with ChangeNotifier {
  WeiplCheckoutFlutter wlCheckoutFlutter = WeiplCheckoutFlutter();
  PAYMENT_OPTIONS PAYMODE = PAYMENT_OPTIONS.COD;

  void changePaymentMode(PAYMENT_OPTIONS op) {
    PAYMODE = op;
    notifyListeners();
  }

  final _repo = ProductRepository();
  bool _is_loading_checkout = false;

  bool get is_loading_checkout => _is_loading_checkout;

  void setLoadingCheckout(bool loading) {
    _is_loading_checkout = loading;
    notifyListeners();
  }

  bool _is_loading = false;

  bool get is_loading => _is_loading;

  var list_product;
  var checkout_details;
  var ORDER_ID;

  void setLoading(bool loading) {
    _is_loading = loading;
    notifyListeners();
  }

  late BuildContext context;
  static const platform =
      MethodChannel('com.softcoresolutions.royal_dry_fruit/channel');
  String _sha1 = '';

  PaymentOptionsViewModel(BuildContext context, var list_product) {
    this.context = context;
    this.list_product = list_product;
    doCheckout();
    _getSha1();
  }

  Future<void> _getSha1() async {
    try {
      final String sha1 = await platform.invokeMethod('getSHA512');

      _sha1 = sha1;
      print(('sha1:$sha1'));
    } on PlatformException catch (e) {
      // _sha1 = "Failed to get SHA1: '${e.message}'.";
    }
  }

  void doCheckout() async {
    setLoadingCheckout(true);
    _repo.doCheckout().then((value) {
      if (value['error'] == 0) {
        checkout_details = value['data'];
        ORDER_ID = value['order_no'];
      } else {
        checkout_details = null;
      }
      Utils.prinAppMessages(value.toString());

      setLoadingCheckout(false);
    }).onError((error, stackTrace) {
      setLoadingCheckout(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  void placeOrder() async {
    print('Ggggggg${list_product['gst_details']}');
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;
    var _data = {
      "address_id": list_product['address_id'],
      "delivery_date": list_product['delivery_date'],
      "delivery_time": list_product['delivery_time'],
      "coupon_code": list_product['coupon_details'] == null
          ? ""
          : list_product['coupon_details']['coupon_code'],
      "gst_id": (list_product['gst_details'] == null ||
              list_product['gst_details'] == '')
          ? ""
          : list_product['gst_details']['gst_id'],
      "order_no": ORDER_ID
    };
    // {"address_id":"1","delivery_date":"2024-08-17","delivery_time":"01:00 PM-04:00 PM","coupon_code":"","gst_id":"","order_no":"12424235"};
    var data = jsonEncode(_data); //json.encode(list_product);
    Utils.prinAppMessages(data);
    setLoading(true);
    _repo.placeOrder(data).then((value) {
      if (value['error'] == 0) {
        Navigator.popAndPushNamed(context, RouteNames.route_thankyou_page,
            arguments: [_data['order_no']]);
      } else {
        Utils.showFlushbarError("${value['msg']}", context);
      }
      Utils.prinAppMessages(value.toString());

      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  void checkCoupons() async {
    var result = await Navigator.pushNamed(
        context, RouteNames.route_coupons_screen,
        arguments: list_product);
    print('coupon res:$result');
    if (result != null) {
      //{"totalSellingPrice":399,"totalMrpPrice":429,"totalSave":30,"totalPayAmout":399,"shipingcharge":0,"couponDisc":0}
      list_product['coupon_details'] = result;
      // Utils.showFlushbarError('Coupon Applied', context);
      // notifyListeners();
      doCheckout();
    }
  }

  getOrderId() {
    DateTime dateTime = DateTime.now();
    return "ORD_${dateTime.year}${dateTime.month}${dateTime.day}${dateTime.hour}${dateTime.minute}${dateTime.second}";
  }

  void makePayment() {
    String deviceID = ""; // initialize variable
    String txnId=ORDER_ID;
    String custId="Cust_1234";
    String custMobNo="8169189257";
    String custEmail="patilsunil8936.sp@gmail.com";
    String merchantId="T1040192";
    String _salt="1764062627XUSNOS";

    //test ids
    // merchantId="T206030";
    // custId="c964634";
    // custMobNo="9876543210";
    // custEmail="test@test.com";
    // txnId="1684835158539";
    // _salt="3976262521OAOQBJ";
    String token="";

    String hashingAlgorithm = 'SHA2';
    if (Platform.isAndroid) {
      List<int> decodedBytes = base64Decode(_sha1);
      String decodedString = String.fromCharCodes(decodedBytes);
      deviceID = _sha1; // Android-specific deviceId, supported options are "AndroidSH1" & "AndroidSH2"
    } else if (Platform.isIOS) {
      deviceID =
          "iOSSH2"; // iOS-specific deviceId, supported options are "iOSSH1" & "iOSSH2"
    }
    DateTime startDate = DateTime.now(); // Current date

    // Format the start date in ISO 8601 format
    var debitStartDate = startDate.toIso8601String();

    // Add 30 years to the start date
    DateTime endDate = DateTime(startDate.year + 30, startDate.month, startDate.day);

    // Format the end date in ISO 8601 format
    String debitEndDate=new DateFormat("dd-MM-yyyy").format(endDate);
    String hashValue = CryptoUtils.generateHash(
      merchantId: merchantId,
      txnId: txnId,
      totalAmount: "10",
      accountNo: "",
      consumerId:custId,
      consumerMobileNo: custMobNo,
      consumerEmailId: custEmail,
      debitStartDate: Utils.getDateInFormat("dd-MM-yyyy"),
      debitEndDate:debitEndDate,
      maxAmount: "10",
      amountType: "Variable",//"Fixed",
      frequency: "ADHO",
      cardNumber: "",//"""4111111111111111",
      expMonth: "",//"""12",
      expYear: "",//"2025",
      cvvCode: "",//"123",
      salt: _salt,
      hashingAlgorithm: hashingAlgorithm,
    );

    print('Generated Hash Value: $hashValue');
    token=hashValue;

     deviceID = ""; // initialize variable

    if (Platform.isAndroid) {
      deviceID = "AndroidSH2"; // Android-specific deviceId, supported options are "AndroidSH1" & "AndroidSH2"
    } else if (Platform.isIOS) {
      deviceID = "iOSSH2"; // iOS-specific deviceId, supported options are "iOSSH1" & "iOSSH2"
    }


   // token="a7356fb644fa98999a45d62361c80a574ff24f96b59669381593edbb97ef4feb0ea427d19e79b8d4ef5d82d38bb0eae890615b5054c702695deef11ec771b751";
     var reqJson = {
      "features": {
        "enableAbortResponse": true,
        "enableExpressPay": true,
        "enableInstrumentDeRegistration": true,
        "enableMerTxnDetails": true
      },
      "consumerData": {
        "deviceId": deviceID,
        "token":token,
        "paymentMode": "all",
        "merchantLogoUrl":
        "https://site.rdfpl.com//include/frontend/assets/imgs/theme/logo.png", //provided merchant logo will be displayed
        "merchantId": merchantId,
        "currency": "INR",
        "consumerId": custId,
        "consumerMobileNo": custMobNo,
        "consumerEmailId": custEmail,
        "txnId":txnId, //Unique merchant transaction ID
        "items": [
          {"itemId": "first", "amount": "2", "comAmt": "0"}
        ],
        "customStyle": {
          "PRIMARY_COLOR_CODE":
          "#45beaa", //merchant primary color code
          "SECONDARY_COLOR_CODE":
          "#FFFFFF", //provide merchant's suitable color code
          "BUTTON_COLOR_CODE_1":
          "#2d8c8c", //merchant"s button background color code
          "BUTTON_COLOR_CODE_2":
          "#FFFFFF" //provide merchant's suitable color code for button text
        }
      }
    };

    var options = {
      "features": {
        "enableAbortResponse": true,
        "enableExpressPay": true,
        "enableInstrumentDeRegistration": true,
        "enableMerTxnDetails": true,
      },
      "consumerData": {
        "deviceId": "ANDROIDSH2",   //supported values "ANDROIDSH1" or "ANDROIDSH2" for Android and supported values "iOSSH1" or "iOSSH2" for iOS
        "token": token,//"e04be9ed85f134a8ca30f609dca6c1f36e742762590daf6ed6edda06275f378a2147f6244ca2295d134beba1e98c6e67140577893b99e6bd34c09d3f2350519c",
        "paymentMode": "all",
        "merchantLogoUrl": "https://www.paynimo.com/CompanyDocs/company-logo-vertical.png", //provided merchant logo will be displayed
        "merchantId": merchantId,//"L3348",
        "currency": "INR",
        "consumerId": custId,//"c964634",
        "consumerMobileNo": custMobNo,
        "consumerEmailId": custEmail,
        "txnId": txnId, //Unique merchant transaction ID
        "items": [
          {"itemId": "first", "amount": "10", "comAmt": "0"}
        ],
        "customStyle": {
          "PRIMARY_COLOR_CODE": "#45beaa", //merchant primary color code
          "SECONDARY_COLOR_CODE": "#FFFFFF", //provide merchant's suitable color code
          "BUTTON_COLOR_CODE_1": "#2d8c8c", //merchant's button background color code
          "BUTTON_COLOR_CODE_2": "#FFFFFF" //provide merchant's suitable color code for button text
        }
      }
    };
    reqJson=options;
    print("RAW PG:$reqJson");
    wlCheckoutFlutter.on(WeiplCheckoutFlutter.wlResponse, handleResponse);
    wlCheckoutFlutter.open(reqJson);
  }

  void handleResponse(Map<dynamic, dynamic> response) {
    print("PG Response:$response");
    String _msg=response['msg'];
    String _payment_status="$response";
    List<String> vales=_msg.split("|");
    if(vales[0]=='0300'){
      print('Payment Done');
    }else if(vales[0]=='0392'){
      _payment_status="Payment Falied\n${vales[2]}";
    }else{
      _payment_status="Payment Falied\n${vales[2]}";
    }
    showAlertDialog(context, "WL SDK Response", "$_payment_status");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons

    Widget continueButton = ElevatedButton(
      child: const Text("Okay"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: Center(child: Text(title)),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SizedBox(
            height: 400,
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Text(message),
                ],
              ),
            ),
          ),
          actions: [
            continueButton,
          ],
        );
      },
    );
  }


}
