import '../data/network/base_api_serivices.dart';
import '../data/network/network_api_servises.dart';
import '../utils/Utils.dart';

class LocationRepository{
  BaseApiServices apiServices=NetworkApiServices();

  Future<dynamic> getLocationResults(dynamic data)async{
    try{

      dynamic response=apiServices.getGetApiResponse('https://maps.googleapis.com/maps/api/place/autocomplete/json'+(data==null?"":data));
      return response;
    }catch(e){
      Utils.prinAppMessages(e.toString());
    }
  }
}

