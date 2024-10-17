import 'dart:convert';
import 'dart:io';

import 'package:alice/core/alice_http_extensions.dart';
import 'package:royal_dry_fruit/data/app_exceptions.dart';
import 'package:royal_dry_fruit/data/network/base_api_serivices.dart';
import 'package:royal_dry_fruit/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:royal_dry_fruit/utils/session_manager.dart';

import '../../main.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetWithBodyApiResponse(String url, data, [headers]) async {
    Utils.prinAppMessages("Url:$url");
    dynamic responseJsonn;
    try {
      var request = http.Request('GET', Uri.parse(url));
      request.body = data;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      responseJsonn = returnResponse2(response);

      //
      //   final response=await http.get(Uri.parse(url),headers: headers).timeout(Duration(minutes: 1))
      //       .interceptWithAlice(alice);
      //   responseJsonn=returnResponse(response);
    } catch (e) {
      Utils.prinAppMessages("API ERROR:${e}");
      // throw FetDataException('No Internet Connection');
      throw FetDataException('API ERROR:${e}');
    }
    return responseJsonn;
  }

  @override
  Future getGetApiResponse(String url, [headers]) async {
    Utils.prinAppMessages("Url:$url");
    dynamic responseJsonn;
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(Duration(minutes: 1))
          .interceptWithAlice(alice);
      Utils.prinAppMessages("API RES:${response.body}");
      responseJsonn = returnResponse(response);
    } catch (e) {
      throw FetDataException('No Internet Connection');
      // throw FetDataException('API ERROR:${e}');
    }
    return responseJsonn;
  }

  @override
  Future getPostApiResponse(String url, data, [headers]) async {
    dynamic responseJsonn;
    try {
      if (headers == null) {
        final response = await http
            .post(
              Uri.parse(url),
              body: data,
            )
            .timeout(Duration(minutes: 1))
            .interceptWithAlice(alice, body: data);
        responseJsonn = returnResponse(response);
      } else {
        final response = await http
            .post(Uri.parse(url),
                body: data,
                encoding: Encoding.getByName("gzip, deflate, br"),
                headers: headers)
            .timeout(Duration(minutes: 1))
            .interceptWithAlice(alice, body: data);
        responseJsonn = returnResponse(response);
      }
    } catch (e) {
      // throw FetDataException('No Internet Connection');
      throw FetDataException('API ERROR:${e}');
    }
    return responseJsonn;
  }

  dynamic returnResponse(http.Response response) {
    updateCookie(response);
    switch (response.statusCode) {
      case 200:
      case 403:
        dynamic json = jsonDecode(response.body);
        return json;
      case 400:
        dynamic json = jsonDecode(response.body);
        return json;
      // throw BadRequestException(response.body);
      case 500:
      case 404:
        throw BadRequestException('${response.body}');
      default:
        throw FetDataException('Error occured while ${response.body.toString()}');
    }
  }

  dynamic returnResponse2(http.StreamedResponse response) async {
   // updateCookie(response);
    switch (response.statusCode) {
      case 200:
      case 403:
      case 405:
        dynamic json = jsonDecode(await response.stream.bytesToString());
        return json;
      case 400:
        dynamic json = jsonDecode(response.reasonPhrase.toString());
        Utils.prinAppMessages("RES:${json.toString()}");
        return json;
      // throw BadRequestException(response.body);
      case 500:
        throw UnCaughtAtServerException('');
      case 404:
        throw BadRequestException('${response.reasonPhrase}');
      default:
        throw FetDataException('Error occured while ');
    }
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      // int? index = rawCookie.indexOf(';');
      // headers['cookie'] =
      //     (index == -1) ? rawCookie : rawCookie.substring(0, index);
      List<String> cookies_list = rawCookie.split(";");
      if (cookies_list.isNotEmpty) {
        for (String _mod in cookies_list) {
          if (_mod != null &&
              _mod.toLowerCase().contains("PHPSESSID".toLowerCase())) {
            String session = _mod;
            new SessionManager().updateSession(session);
            print('Updating token------------------------------------------------------\n${session}');
            break;
          }
        }
      }

      // String? rawCookie = response.headers['set-cookie'];
      // if (rawCookie != null) {
      //   int index = rawCookie.indexOf(';');
      //   String cookie =
      //   (index == -1) ? rawCookie : rawCookie.substring(0, index);
      //   new SessionManager().updateSession(cookie);
      //   print('Updating token------------------------------------------------------\n${cookie}');
      // }
    }
  }
}
