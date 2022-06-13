import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rest_countries_app/constants/models/Country.dart';
import 'package:rest_countries_app/utils/rest_api_services.dart';

class CountryProvider extends ChangeNotifier {
  late Country _country;
  late List<Country> _countries = [];
  late List<Country> _floatingCountries = [];
  late List<Country> _countriesToExport = [];

  Country get country => _country;

  List<Country> get countries => _countries;

  List<Country> get floatingCountries => _floatingCountries;

  List<Country> get countriesToExport => _countriesToExport;

  void initializeFloatingCountries() {
    _floatingCountries = _countries;
    notifyListeners();
  }

  void updateFloatingCountries(List<Country> countries) {
    _floatingCountries = countries;
    notifyListeners();
  }

  Future fetchToExport() {
    return RestApiServices.instance.byRequiredAttr().then((data) {
      data.forEach((object) {
        _countriesToExport.add(Country.fromJson(object));
      });
      notifyListeners();
    });
  }

  Future fetchAllCountries() {
    return RestApiServices.instance.byAll().then((data) {
      data.forEach((object) {
        _countries.add(Country.fromJson(object));
      });
      notifyListeners();
    });
  }

  Future fetchByName(String countryName) {
    return RestApiServices.instance.byName(countryName).then((data) {
      _country = Country.fromJson(data[0]);
      notifyListeners();
    });
  }
}
