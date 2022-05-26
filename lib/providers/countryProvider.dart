import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rest_countries_app/constants/models/Country.dart';
import 'package:rest_countries_app/utils/rest_api_services.dart';

class CountryProvider extends ChangeNotifier {
  late Country _country;
  late List<Country> _countries = [];
  late List<Country> _floatingCountries = [];

  Country get country => _country;
  List<Country> get countries => _countries;
  List<Country> get floatingCountries => _floatingCountries;

  void initializeFloatingCountries(){
    _floatingCountries = _countries;
    notifyListeners();
  }

  void updateFloatingCountries(List<Country> countries){
    _floatingCountries = countries;
    notifyListeners();
  }

  Future fetchAllCountries() {
    return RestApiServices.instance.byAll().then((data) {
      data.forEach((object) {
        // print(object);
        // print(c.flagUrl);
        // print(c.flagUrl);
        _countries.add(Country.fromJson(object));
        // object.forEach((key, value) {
        //   print('$key: $value');
        // });
      });
      // data.forEach((key, value) { print('key: $key value $value');});
      // print(data);
      notifyListeners();
    });
  }

  Future fetchByName(String countryName){
    return RestApiServices.instance.byName(countryName).then((data){
      _country = Country.fromJson(data[0]);
      notifyListeners();
    });

  }

}
