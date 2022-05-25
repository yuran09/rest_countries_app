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
        flagUrl: json['flags']['png']?? 'n/a',
        capital: json['capital']?? 'n/a',
        region: json['region']?? 'n/a',
        subRegion: json['subregion']?? 'n/a',
        population: json['population']?? 'n/a',
        area: json['area']?? 'n/a',
        timezone: json['timezones']?? 'n/a',
        nativeName: json['nativeName']?? 'n/a'
    );
  }
}
