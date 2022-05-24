import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rest_countries_app/constants/api_constants.dart';

class RestApiServices{
  static RestApiServices instance = RestApiServices();
  static Dio dio = Dio();

  Future _sendGetRequest(String url) async{
    try{
      var response = await dio.get(url);
      print(url);
      print(response.statusCode);
      // print(response.data[0]['capital']);
      if (response.statusCode! >= 200 || response.statusCode! <= 299) {
        // Success
        return response.data;
      }
      else {
        throw Exception();
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future byName(String data) async {
    return await _sendGetRequest('$apiUrl'+'$nameUrl' + '/$data');
  }

  Future bySubRegion(String data) async {
    return await _sendGetRequest('$apiUrl'+'$nameUrl' + '/$data');
  }

  Future byAll() async {
    return await _sendGetRequest(v2AllUrl);
  }
}