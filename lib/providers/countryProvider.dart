import 'package:flutter/material.dart';
import 'package:rest_countries_app/constants/models/Country.dart';
import 'package:rest_countries_app/utils/rest_api_services.dart';

class CountryProvider extends ChangeNotifier{
  late Country _country;
  late List<Country> _countries = [];

  Future fetchAllCountries(){
    return RestApiServices.instance.byAll().then((data) {
      print(data);
    });
  }

}