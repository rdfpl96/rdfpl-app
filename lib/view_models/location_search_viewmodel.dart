import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:royal_dry_fruit/repositories/locations_search_repository.dart';
import 'package:royal_dry_fruit/repositories/product_repository.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';

import '../utils/session_manager.dart';

class LocationSearchViewModel with ChangeNotifier{
  var _repo=LocationRepository();

  TextEditingController tec_location=TextEditingController();
  BuildContext context;
  var list_locations;

  bool _loading=false;


  bool get loading=>_loading;
  setLoading(bool loading){
    _loading=loading;
    notifyListeners();
  }

  LocationSearchViewModel(this.context){

  }


  void searchLocations( BuildContext context)async {
    if(tec_location.text==''){
      list_locations=null;
      return;
    }
    if(tec_location.text.length<3){
      return;
    }
  var raw_data="?input=${tec_location.text}&key=AIzaSyDUksStRc1nu8vDYcb8245lsuPz7l9GUg0";//"&location=37.76999%2C-122.44696 &radius=500 &types=establishment ";

    Utils.prinAppMessages(raw_data);
    setLoading(true);
    _repo.getLocationResults(raw_data).then((value) {
      setLoading(false);

      // if((value['predictions'])!=null) {
        list_locations=value;
      // }
    }).onError((error, stackTrace) {
      setLoading(false);
      Utils.showFlushbarError(error.toString(),context);
      Utils.prinAppMessages(error.toString());
    });
  }


}