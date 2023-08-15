import 'package:geocoding/geocoding.dart';

class Address {
  final String? road;
  final String? county;
  final String? state;
  final String? iso;
  final String? country;
  final String? countryCode;

  Address({
    this.road,
    this.county,
    this.state,
    this.iso,
    this.country,
    this.countryCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        road: json['road'],
        county: json['county'],
        state: json['state'],
        iso: json['ISO3166-2-lvl4'],
        country: json['country'],
        countryCode: json['country_code'],
      );

  factory Address.fromPlacemark(Placemark placemark) => Address(
        country: placemark.country,
        countryCode: placemark.isoCountryCode,
        iso: placemark.isoCountryCode,
        road: placemark.street,
        state: placemark.administrativeArea,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['road'] = road;
    data['county'] = county;
    data['state'] = state;
    data['ISO3166-2-lvl4'] = iso;
    data['country'] = country;
    data['country_code'] = countryCode;
    return data;
  }
}
