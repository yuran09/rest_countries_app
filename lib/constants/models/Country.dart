class Country {
  final String name;
  final String flagUrl;
  final String capital;
  final String region;
  final String subRegion;
  final String population;
  final String area;
  final String timezone;
  final String nativeName;

  factory Country.fromJson(Map<String, dynamic> json){
    return Country(
        name: json['name'],
        flagUrl: json['flags']['png'],
        capital: json[''],
        region: json[''],
        subRegion: json[''],
        population: json[''],
        area: json[''],
        timezone: json[''],
        nativeName: json['']
    );
  }

  Country(this.name, this.flagUrl, this.capital, this.region, this.subRegion,
      this.population, this.area, this.timezone, this.nativeName);

}