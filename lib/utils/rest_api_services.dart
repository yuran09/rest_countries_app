import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rest_countries_app/constants/api_constants.dart';

class RestApiServices{
  static RestApiServices instance = RestApiServices();
  static Dio dio = Dio();

  Future _sendGetRequest(String url) async{
    try{
      var response = await dio.get(url);
      print(response.statusCode);
      // print(response.data[0]['capital']);
      if (response.statusCode! >= 200 || response.statusCode! <= 299) {
        // Success
        return response.data[0];
      }
      else {
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> byName(String data) async {
    return await _sendGetRequest('$apiUrl'+'$nameUrl' + '/$data');
  }

  Future<Map<String, dynamic>> bySubRegion(String data) async {
    return await _sendGetRequest('$apiUrl'+'$nameUrl' + '/$data');
  }

  Future<Map<String, dynamic>> byAll() async {
    return await _sendGetRequest('$apiUrl'+'/all?fields=name');
  }
}