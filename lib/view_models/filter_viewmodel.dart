import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/models/filter_price_model.dart';
enum SORT_BY{RELE,HTOL,LTOH}
class FilterViewmodel with ChangeNotifier {
  var filter = [];
  SORT_BY selected_sort=SORT_BY.RELE;

  // SORT_BY sort_by=SORT_BY.RELE;


  void setSort(int i,var val){

    selected_sort=val;
     notifyListeners();
  }

  late List<FilterPriceModel> filterPriceList;

  FilterViewmodel() {
    filterPriceList = FilterPriceModel.generateFilterList();
  }

  void setPriceFilter(bool val,FilterPriceModel itm) {
    for(int i=0;i<filterPriceList.length;i++){
      filterPriceList[i].isSelected=false;
      if(filterPriceList[i].filterName==itm.filterName){
        filterPriceList[i].isSelected=val;
      }
    }
    notifyListeners();
  }

  void addFilter(bool? value, e) {
    if (value == true) {
      // for(int i=0;i<filter.length;i++){
      //   if(filter[i]==e) {
      filter.add(e);
      // }
      // }
    } else {
      for (int i = 0; i < filter.length; i++) {
        if (filter[i] == e) {
          filter.remove(e);
        }
      }
    }
  }

  String getPriceSelectedFilter() {
    for(int i=0;i<filterPriceList.length;i++){

      if(filterPriceList[i].isSelected){
        return filterPriceList[i].value;
      }
    }
    return "";
  }
}
