import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../repositories/delivery_address_repository.dart';
import '../utils/Utils.dart';
import '../utils/routes/routes_name.dart';
import '../utils/session_manager.dart';
import '../utils/AppUtils.dart';

class DeliveryOptionsViewModel with ChangeNotifier {
  final _repo = DeliveryAddressRepository();
  bool _is_loading = false;
  bool _is_loading_add_gst = false;
  bool _is_loading_gst = false;
  bool _is_gst_detsails = false;

  bool get is_loading => _is_loading;

  bool get is_loading_add_gst => _is_loading_add_gst;

  bool get is_gst_detsails => _is_gst_detsails;
  bool get is_loading_gst => _is_loading_gst;

  void setIsGst(bool value) {
    _is_gst_detsails = value;
    notifyListeners();
  }
  void setLoadingGst(bool value){
    _is_loading_gst=value;
    notifyListeners();
  }

  var add_list;

  void setLoading(bool loading) {
    _is_loading = loading;
    notifyListeners();
  }

  void setLoadingAddGst(bool loading) {
    _is_loading_add_gst = loading;
    notifyListeners();
  }

  late BuildContext context;
  var cart_list;
  var DATA;

  DeliveryOptionsViewModel(BuildContext context, var cart_list, var DATA) {
    this.context = context;
    this.cart_list = cart_list;
    this.DATA = DATA;
    Utils.prinAppMessages("CART DET:${cart_list}");
    getDefaultAddress();
  }

  TextEditingController tecGst = TextEditingController();
  TextEditingController tecGstCompName = TextEditingController();
  TextEditingController tecGstCompAddress = TextEditingController();
  TextEditingController tecPincode = TextEditingController();
  TextEditingController tecFssaiNo = TextEditingController();
  TextEditingController tecMobileNo = TextEditingController();
  TextEditingController tecEmail = TextEditingController();

  void getDefaultAddress() async {
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;
    var data = json.encode({
      "customer_id":
          (await SessionManager().getString(SessionManager.KEY_UserId))!
    });
    Utils.prinAppMessages(data);
    setLoading(true);
    _repo.getDefaultAddress().then((value) {
      if (value['error'] == 0) {
        var _address = value['data']['addresses'] as List;
        for (int i = 0; i < _address.length; i++) {
          if (_address[i]['setAddressDefault'] == "1") {
            add_list = _address[i];
          }
        }
      }
      Utils.prinAppMessages(value.toString());

      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
    getDeliverySlots();
  }

  String? GST_ID;

  void saveGSTDetails() async {
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;
    var data = json.encode({
      "customer_id":
          (await SessionManager().getString(SessionManager.KEY_UserId))!,
      "registration_no": tecGst.text,
      "company_name": tecGstCompName.text,
      "company_address": tecGstCompAddress.text,
      "pincode": tecPincode.text,
      "fssai_no": tecFssaiNo.text,
      "mobile": tecMobileNo.text,
      "email_id": tecEmail.text
    });
    Utils.prinAppMessages(data);
    setLoadingAddGst(true);
    _repo.addGSTDetails(data).then((value) {
      if (value['error'] == 0) {
        Utils.showFlushbarError("${value['msg']}", context, false);
        GST_ID = value['gst_id'] == null ? "" : value['gst_id'].toString();
      } else /*if (value['status'] == 400)*/ {
        Utils.showFlushbarError("${value['msg']}", context);
      }
      Utils.prinAppMessages(value.toString());

      setLoadingAddGst(false);
    }).onError((error, stackTrace) {
      setLoadingAddGst(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  var gst_details;
  void getGSTDetails() async {
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;

    setLoadingGst(true);
    _repo.getGSTDetails().then((value) {
      if (value['error'] == 0) {
        gst_details=value['data'];
        print('gst_details:$gst_details');
        if(gst_details!=null ) {
          try {
            tecGstCompName.text = gst_details['company_name'];
            tecGstCompAddress.text = gst_details['company_address'];
            tecPincode.text = gst_details['pincode'];
            tecGst.text = gst_details['registration_no'];
            tecFssaiNo.text = gst_details['fssai_no'];
            tecMobileNo.text =
            gst_details['mobile'] == null ? "" : gst_details['mobile'];
            tecEmail.text =
            gst_details['email_id'] == null ? "" : gst_details['email_id'];
            GST_ID = "${gst_details['id']}";
          }catch(ee){
            print("Error in Parsing:$ee");
          }
        }
      } else /*if (value['status'] == 400)*/ {
        Utils.showFlushbarError("${value['msg']}", context);
      }
      Utils.prinAppMessages(value.toString());

      setLoadingGst(false);
    }).onError((error, stackTrace) {
      setLoadingGst(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });
  }

  var _selected_slot;

  get selected_slot => _selected_slot;

  void changeSlot(var slot) {
    _selected_slot = slot;
    notifyListeners();
  }

  bool _is_loading_slots = false;

  bool get is_loading_slots => _is_loading_slots;
  var slots_list = [];

  void setLoadingSlots(bool loading) {
    _is_loading_slots = loading;
    notifyListeners();
  }

  // Format dates
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void getDeliverySlots() async {
    setLoadingSlots(true);
    _repo.getDeliverySlots().then((value) {
      if (value['error'] == 0) {
        // Get current date
        DateTime currentDate = DateTime.now();
        var _data = {
          'date': formatDate(currentDate),
          'date_title': 'Today',
          'slots': value['data']
        };

        slots_list.add(_data);

        // Get the next 3 days' dates
        List<String> nextDates = List.generate(4, (index) {
          return formatDate(currentDate.add(Duration(days: index)));
        });
        for (int i = 0; i < nextDates.length; i++) {
          String title = nextDates[i];
          if (i == 0) {
            title = 'Tomorrow';
          }
          _data = {
            'date': nextDates[i],
            'date_title': title,
            'slots': value['data']
          };

          slots_list.add(_data);
        }
      } else /*if (value['status'] == 400)*/ {
        Utils.showFlushbarError("${value['msg']}", context);
      }
      Utils.prinAppMessages(value.toString());

      setLoadingSlots(false);
      getGSTDetails();
    }).onError((error, stackTrace) {
      getGSTDetails();
      setLoadingSlots(false);
      Utils.showFlushbarError(error.toString(), context);
      Utils.prinAppMessages(error.toString());
    });

  }

  void next() async {
    if (selected_slot == null) {
      Utils.showFlushbarError(
        "Select Delivery Slot",
        context,
      );
      return;
    }
    if (add_list == null) {
      Utils.showFlushbarError(
        "Select Delivery Address",
        context,
      );
      return;
    }
    if (is_gst_detsails == true && GST_ID == "") {
      Utils.showFlushbarError(
        "Enter GST Details",
        context,
      );
      return;
    }
    print("Selected Slot:$_selected_slot");
    var data = {
      "customer_id": (await SessionManager().getString(SessionManager.KEY_UserId))!,
      "cart": cart_list,
      "address_id": add_list['addr_id'],
      "delivery_date":Utils.getDate(_selected_slot['date'], "dd/MM/yyy", "yyyy-MM-dd"),
      "delivery_time":'${_selected_slot['slots']['start_time']}-${_selected_slot['slots']['end_time']}',
      "coupon_details": null /*{
        "purchase_type": "amount_purchase",
        "min_purch_amt": "3000.00",
        "min_purch_qty": "0.000",
        "coupon_codes": "L9E2NM",
        "purchaseOrderAmountWithDisc": "2600.00",
        "couponValue": "400.00",
        "originalPurchaseAmount": "3000.00",
        "usertype": "individual",
        "coupon_use": "multi_use",
        "cust_id": "3",
        "cust_email": "krishnamurari.prajapati@softcoresolutions.com"
      }*/
      ,
      "gst_details_apply": is_gst_detsails ? 1 : 0,
      "gst_details": is_gst_detsails
          ? {
              "gst_id": GST_ID,
              "gst_no": tecGst.text,
              "registered_company_name": tecGstCompName.text,
              "registered_company_address": tecGstCompAddress.text
            }
          : "",
      "total_amount": DATA['subTotal'],
      "total_itemsWeightKg": '0' //DATA['itemsWeight']
    };
    Navigator.pushNamed(context, RouteNames.route_payment_options,
        arguments: data);
  }
}
