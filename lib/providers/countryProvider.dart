import 'package:flutter/material.dart';
import 'package:rest_countries_app/constants/models/Country.dart';
import 'package:rest_countries_app/utils/rest_api_services.dart';

class CountryProvider extends ChangeNotifier {
  late Country _country;
  late List<Country> _countries = [];

  List<Country> get countries => _countries;

  Future fetchAllCountries() {
    return RestApiServices.instance.byAll().then((data) {
      data.forEach((object) {
        Country c = Country.fromJson(object);
        print(c.name);
        _countries.add(c);
        // object.forEach((key, value) {
        //   print('$key: $value');
        // });
      });
      // data.forEach((key, value) { print('key: $key value $value');});
      // print(data);
      notifyListeners();
    });
  }
}
