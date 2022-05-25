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

  const Country(
      {required this.name,
      required this.flagUrl,
      required this.capital,
      required this.region,
      required this.subRegion,
      required this.population,
      required this.area,
      required this.timezone,
      required this.nativeName});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
        name: json['name'],
        flagUrl: json['flag']?? 'n/a',
        capital: json['']?? '',
        region: json['']?? '',
        subRegion: json['']?? '',
        population: json['']?? '',
        area: json['']?? '',
        timezone: json['']?? '',
        nativeName: json['']?? ''
    );
  }
}
