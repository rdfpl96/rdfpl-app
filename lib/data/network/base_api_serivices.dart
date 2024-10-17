abstract class BaseApiServices{
  Future<dynamic> getGetWithBodyApiResponse(String url,dynamic data,[var headers]);
  Future<dynamic> getGetApiResponse(String url,[var headers]);
  Future<dynamic> getPostApiResponse(String url,dynamic data,[var headers]);
}