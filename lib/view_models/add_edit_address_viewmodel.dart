import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:royal_dry_fruit/repositories/auth_repository.dart';
import 'package:royal_dry_fruit/repositories/home_repository.dart';
import 'package:royal_dry_fruit/repositories/myaccount_repository.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:royal_dry_fruit/utils/routes/routes_name.dart';
import 'package:royal_dry_fruit/utils/session_manager.dart';
// import 'package:ecommerce_app_design/views/auth/MobNo_OtpScreen.dart';
// import 'package:ecommerce_app_design/views/auth/Upload_ProfileDet.dart';
import 'package:flutter/material.dart';

import '../repositories/delivery_address_repository.dart';
import 'package:http/http.dart' as http;
class AddEditAddressViewModel with ChangeNotifier{

  final _repo=DeliveryAddressRepository();
  bool _loading=false;
  bool _loading_state=false;
  bool _loading_city=false;
  bool _loading_address=false;
  bool _chk_set_as_default=false;




  bool get chk_set_as_default => _chk_set_as_default;

  set chk_set_as_default(bool value) {
    _chk_set_as_default = value;
    notifyListeners();
  }

  var add_list=[];
  var state_list;
  var city_list;
  var cat_list=[];

  bool get loading=>_loading;
  bool get loading_city=>_loading_city;
  bool get loading_address=>_loading_address;
  bool get loading_state=>_loading_state;

  setLoadingState(bool loading){
    _loading_state=loading;
    notifyListeners();
  }

  setLoading(bool loading){
    _loading=loading;
    notifyListeners();
  }
  setLoadingCity(bool loading){
    _loading_city=loading;
    notifyListeners();
  }
  setLoadingAddress(bool loading){
    _loading_address=loading;
    notifyListeners();
  }


  TextEditingController tec_HoNo=TextEditingController();
  TextEditingController tec_AprtName=TextEditingController();
  TextEditingController tec_Street  =TextEditingController();
  TextEditingController tec_Area  =TextEditingController();
  TextEditingController tec_Pincode  =TextEditingController();
  TextEditingController tec_Name  =TextEditingController();
  TextEditingController tec_LName  =TextEditingController();
  TextEditingController tec_Mobile  =TextEditingController();
  TextEditingController tec_Other  =TextEditingController();
  TextEditingController tec_city  =TextEditingController();

  late String _addType='Home';

  Map<String,dynamic>? _selected_city;
  Map<String,dynamic>? _selected_state/*={
    "name":'Select State',
    "country_id":-1
  }*/;


  Map<String,dynamic>? get selected_state => _selected_state;
  Map<String,dynamic>? get selected_city => _selected_city;

  void changeState(Map<String,dynamic>? value) {
    _selected_state = value;
    notifyListeners();
  }
  void changeCity(Map<String,dynamic>? value) {
    _selected_city = value;
    notifyListeners();
  }

  set addType(String value) {
    _addType = value;
    notifyListeners();
  }


  String get addType => _addType;
  LatLng? latLng;
  String? address;
  late bool isSkip;
  AddEditAddressViewModel(BuildContext context,LatLng latLng,String address,String? address_id,bool isSkip){
    this.isSkip=isSkip;
    this.address_id=address_id;
    this.latLng=latLng;
    this.address=address;
    print('address id:$address_id');

    getAddress(context, address_id);

  }


  void getStateList( BuildContext context)async {
    state_list=[];
    // state_list.add({
    //   "name":'Select State',
    //   "country_id":-1
    // });
    setLoadingState(true);
    _repo.getStateList().then((value) {

      if(value['error']==0) {
        state_list.addAll(value['data']);
        if(add_list!=null) {
          List _list_state=(state_list as List);
          List _list_add=(add_list as List);
          for(int i=0;i<_list_state.length;i++){
            if(add_list!=null && _list_add.isNotEmpty){
              if(_list_add[0]['addr_id']==address_id && _list_add[0]['state_id']==_list_state[i]['id']){
                changeState(_list_state[i]);
                getCityList(context);
              }
            }
          }
        }

      }else if(value['status']==400){
        Utils.showFlushbarError("${value['message']}", context);
      }
      fetchAddress(latLng!.latitude, latLng!.longitude);
      setLoadingState(false);
      Utils.prinAppMessages(value.toString());
    }).onError((error, stackTrace) {
      setLoadingState(false);
      fetchAddress(latLng!.latitude, latLng!.longitude);

      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });
  }
  void getCityList( BuildContext context)async {
    if(true){return;}
    if(selected_state==null){
      return;
    }
    _selected_city=null;
    city_list=[];
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;
    var data=json.encode({
      "state_id":_selected_state!['id'],
      "city_id":""
    });
    Utils.prinAppMessages(data);
    setLoadingCity(true);
    _repo.getCityList(data).then((value) {


      if(value['status']==200) {
        city_list=value['response'];
        if(add_list!=null) {
          List _list_city = (city_list as List);
          List _list_add = (add_list as List);
          for (int i = 0; i < _list_city.length; i++) {
            if (add_list != null && _list_add.isNotEmpty) {
              if (_list_add[0]['addr_id'] == address_id &&
                  _list_add[0]['city_id'] == _list_city[i]['id']) {
                changeCity(_list_city[i]);
              }
            }
          }
        }

      }else if(value['status']==400){
        Utils.showFlushbarError("${value['message']}", context);
      }
      Utils.prinAppMessages (value.toString());
      setLoadingCity(false);
    }).onError((error, stackTrace) {
      setLoadingCity(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });
  }

  String? address_id;
  void getAddress( BuildContext context,String? address_id)async {

    add_list=[];
    this.address_id=address_id;
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;
    if(address_id==null || address_id==""){
    //
    //   // tec_HoNo.text = '';
    //   // tec_AprtName.text = '';
    //   // tec_Street.text = '';
    //   // tec_Area.text = '';
    //   // tec_Pincode.text = '';
    //   // tec_Name.text = '';
    //   // tec_LName.text = '';
    //   // tec_Mobile.text = '';
    //   // tec_Other.text = '';
      getStateList(context);
    //
    }else {
      var data = json.encode({
        "customer_id": (await SessionManager().getString(SessionManager.KEY_UserId))!,
        "address_id": address_id,
      });
      Utils.prinAppMessages(data);
      setLoadingAddress(true);
     await _repo.getDelveryAddress().then((value) {
       setLoadingAddress(false);
        if (value['error'] == 0) {
          add_list.clear();
          List _list = value['data']['addresses']as List;
          for(int i=0;i<_list.length;i++){
            if(_list[i]['addr_id'].toString()==address_id){
              add_list.add(_list[i]);
              tec_HoNo.text = _list[i]['address1'];
              tec_AprtName.text = _list[i]['address2'];
              tec_Street.text = _list[i]['landmark'];
              tec_Area.text = _list[i]['area'];
              tec_Pincode.text = _list[i]['pincode'];
              tec_Name.text = _list[i]['fname'];
              tec_LName.text = _list[i]['lname'];
              tec_Mobile.text = _list[i]['mobile'];
              tec_Other.text = _list[i]['others']==null?"":_list[i]['others'];
              tec_city.text = _list[i]['city'];
              _addType = _list[i]['nick_name']==null?'Home':_list[i]['nick_name'];
            }
          }
          // if (_list.isNotEmpty) {
          //   tec_HoNo.text = _list[0]['address1'];
          //   tec_AprtName.text = _list[0]['address2'];
          //   tec_Street.text = _list[0]['landmark'];
          //   tec_Area.text = _list[0]['area'];
          //   tec_Pincode.text = _list[0]['pincode'];
          //   tec_Name.text = _list[0]['fname'];
          //   tec_LName.text = _list[0]['lname'];
          //   tec_Mobile.text = _list[0]['mobile1'];
          //   tec_Other.text = _list[0]['others'];
          //
          //   _addType = _list[0]['nick_name'];
          // }

        } else if (value['status'] == 400) {
          Utils.showFlushbarError("${value['message']}", context);
        }
        Utils.prinAppMessages(value.toString());

      }).onError((error, stackTrace) {

        setLoadingAddress(false);

        Utils.showFlushbarError(error.toString(), context);
        Utils.prinAppMessages(error.toString());
      });
      getStateList(context);
    }
  }


  saveOrEditAddress(BuildContext context)async {


    if(tec_AprtName.text==''){
      Utils.showFlushbarError('Enter Apartment Name', context);
      return;
    }
    if(tec_HoNo.text==''){
      Utils.showFlushbarError('Enter House No', context);
      return;
    }
    if(tec_Area.text==''){
      Utils.showFlushbarError('Enter Area', context);
      return;
    }
    if(tec_city.text==''){
      Utils.showFlushbarError('Enter City', context);
      return;
    }
    if(tec_Pincode.text==''){
      Utils.showFlushbarError('Enter Pincode', context);
      return;
    }
    if(tec_Name.text==''){
      Utils.showFlushbarError('Enter First Name', context);
      return;
    }
    if(tec_LName.text==''){
      Utils.showFlushbarError('Enter Last Name', context);
      return;
    }
    if(tec_Mobile.text==''){
      Utils.showFlushbarError('Enter Mobile', context);
      return;
    }
    // var data="customer_id="+(await  SessionManager().getString(SessionManager.KEY_UserId))!;
    if(_selected_state==null){
      Utils.showFlushbarError('Select State', context);
      return;
    }
    if(tec_city.text==null){
      Utils.showFlushbarError('Select City', context);
      return;
    }
    if(_loading){return;}
    print('Address id======$address_id');

    if(address_id==null || address_id=='') {

      var data = json.encode({
        "fname": tec_Name.text,
        "lname": tec_LName.text,
        "mobile": tec_Mobile.text,
        "apart_house": tec_HoNo.text,
        "apart_name": tec_AprtName.text,
        "area": tec_Area.text,
        "street_landmark": tec_Street.text,
        "state": selected_state!['id'],
        "city": tec_city.text,
        "pincode": tec_Pincode.text,
        // "address_type":"shippingAddress",
        "address_type": "shippingAddress",
        "others": tec_Other.text,
        "setAddressDefault": chk_set_as_default?'1':'0',

        "nick_name": _addType,
        "location_type": _addType,
        "address_id": address_id == null ? "" : address_id
      });
      Utils.prinAppMessages(data);
      setLoading(true);
      _repo.addOrEditAddress(data).then((value) {
        setLoading(false);

        if (value['error'] == 0) {
          //Navigator.pushNamedAndRemoveUntil(context, RouteNames.route_home,(Route<dynamic> route) => false);
          nextScreen(context);
        } else {
          Utils.showFlushbarError("${value['msg']}", context);
        }
        Utils.prinAppMessages(value.toString());
      }).onError((error, stackTrace) {
        setLoading(false);
        Utils.showFlushbarError(error.toString(), context);
        Utils.prinAppMessages(error.toString());
      });
    }else{
      var data = json.encode({
        "fname": tec_Name.text,
        "lname": tec_LName.text,
        "mobile": tec_Mobile.text,
        "apart_house": tec_HoNo.text,
        "apart_name": tec_AprtName.text,
        "area": tec_Area.text,
        "street_landmark": tec_Street.text,
        "state": selected_state!['id'],
        "city": tec_city.text,
        "pincode": tec_Pincode.text,
        // "address_type":"shippingAddress",
        "address_type":"shippingAddress", //Home,office
        "others": tec_Other.text,
        "setAddressDefault":  chk_set_as_default?'1':'0',
        "nick_name": _addType,
        "location_type": _addType,
        "address_id": address_id == null ? "" : address_id
      });
      Utils.prinAppMessages(data);
      setLoading(true);
      _repo.editAddress(data).then((value) {
        setLoading(false);

        if (value['error'] == 0) {
          // Navigator.pushNamedAndRemoveUntil(context, RouteNames.route_home,(Route<dynamic> route) => false);
          nextScreen(context);

        } else {
          Utils.showFlushbarError("${value['msg']}", context);
        }
        Utils.prinAppMessages(value.toString());
      }).onError((error, stackTrace) {
        setLoading(false);
        Utils.showFlushbarError(error.toString(), context);
        Utils.prinAppMessages(error.toString());
      });
    }
  }

  bool _is_load_gaddress=false;

  bool get is_load_gaddress => _is_load_gaddress;
  void setGLoading(bool loading){
    _is_load_gaddress=loading;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getAddressFromLatLng(double lat, double lng) async {
    final String apiKey = "AIzaSyDUksStRc1nu8vDYcb8245lsuPz7l9GUg0";
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey";
    print("Url:$url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);
      if (result['results'] != null && result['results'].isNotEmpty) {
        return result['results'][0];
      }
    } else {
      print("Failed to fetch address: ${response.statusCode}");
    }
    return null;
  }
  Future<void> fetchAddress(double lat, double lng) async {
    setGLoading(true);
    final addressDetails = await getAddressFromLatLng(lat, lng);

    if (addressDetails != null) {
      String? city;
      String? state;
      String? postalCode;

      List<dynamic> addressComponents = addressDetails['address_components'];

      for (var component in addressComponents) {
        List<dynamic> types = component['types'];

        if (types.contains('locality')) {
          city = component['long_name'];
        } else if (types.contains('administrative_area_level_1')) {
          state = component['long_name'];
        } else if (types.contains('postal_code')) {
          postalCode = component['long_name'];
        }
      }

      print("Suuuuuuuuuuuuuuuuun: City: $city, State: $state, Postal Code: $postalCode");
      tec_city.text=city==null?'':city;
      tec_Pincode.text=postalCode==null?'':postalCode;


      getSelectedState(state);
    }
    setGLoading(false);
  }

  getSelectedState(String? state) {
    for(int i=0;i<(state_list as List).length;i++){
      if(state_list[i]['name'].toString().toLowerCase()==state!.toLowerCase()){
        changeState(state_list[i]);
      }
    }
  }

  void nextScreen(BuildContext context) {
    print('iSkip:$isSkip');
    if(!isSkip) {
      Navigator.pop(context);
    }
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);

    Navigator.pushNamed(context,
        RouteNames.route_delivery_address_screen);
  }

}