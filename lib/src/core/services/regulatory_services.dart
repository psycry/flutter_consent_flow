import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_consent_flow/src/core/models/address.dart';
import 'package:flutter_consent_flow/src/core/services/global_services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../enums/enums.dart';

void log(String log) {
  final enableLogs = GlobalServices.instance.enableLogs;
  if (enableLogs) {
    debugPrint('FLUTTER_CONSENT_FLOW : $log');
  }
}

class RegulatoryServices {
  static Future<RegulatoryFramework?> checkRegulatoryFrameworkByIP({
    required String apiKey,
    VoidCallback? ifFailed,
    String? mockIP,
  }) async {
    log('Getting regulatory framework by user IP');
    String url =
        'https://api.ipgeolocation.io/ipgeo?apiKey=$apiKey&output=json';
    if (mockIP != null) {
      url += '&ip=$mockIP';
    }
    log('Making request to api.ipgeolocation.io');
    log('End-point was set to $url');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        log('Requst to $url succeeded!');
        final Map<String, dynamic> data = json.decode(response.body);
        log('Got the results from API => $data');
        switch (data['country_code2'].toString().toUpperCase()) {
          case 'US':
            if (data['state_prov'].toLowerCase() == 'california') {
              /// User is in California (CCPA)
              return RegulatoryFramework.ccpa;
            }
            break;
          case 'BR':
            // User is in Brazil (LGPD)
            return RegulatoryFramework.lgpd;
          default:
            if (_euCountries.contains(data['country_code2'].toUpperCase())) {
              return RegulatoryFramework.gdpr;
            } else {
              return RegulatoryFramework.notApplied;
            }
        }
      } else {
        log('Cannot fetch data from API');
        log('STATUS CODE : ${response.statusCode}, Error : ${response.body}');
        ifFailed?.call();
      }
    } catch (e, s) {
      log('Cannot fetch data from API');
      log(e.toString());
      log(s.toString());
      ifFailed?.call();
    }

    return null;
  }

  static Future<RegulatoryFramework?> checkRegulatoryFrameworkByCoordinates({
    bool useGeocoderIfFails = false,
    VoidCallback? ifFailed,
  }) async {
    log('Getting regulatory framework by user coordinates');

    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    log('user location : ${position.latitude},${position.longitude}');
    // Use a openstreetmap or geolocation API to get the data from the coordinates
    Address? address;
    try {
      address = await _getAddressByOpenstreetmap(
        position: position,
        httpReferer: GlobalServices.instance.httpReferer,
        userAgent: GlobalServices.instance.userAgent,
      );
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    }

    //// if the openstreetmap API fails, use geocoder API. (NOT RECOMMENDED BY GOOGLE)
    /// more @https://developer.android.com/reference/android/location/Geocoder
    if (address == null && useGeocoderIfFails) {
      try {
        address =
            await _getAddressByGeocoder(position.latitude, position.longitude);
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
      }
    }

    log('User\'s address => ${address?.toJson()}');

    if (address != null) {
      switch (address.countryCode?.toUpperCase()) {
        case 'US':
          if (address.state?.toLowerCase() == 'california') {
            /// User is in California (CCPA)
            return RegulatoryFramework.ccpa;
          }
          break;
        case 'BR':
          // User is in Brazil (LGPD)
          return RegulatoryFramework.lgpd;
        default:
          if (_euCountries.contains(address.countryCode?.toUpperCase())) {
            return RegulatoryFramework.gdpr;
          } else {
            return RegulatoryFramework.notApplied;
          }
      }
    } else {
      ifFailed?.call();
      log('Unable to find the user\'s address');
    }
    return null;
  }

  static Future<Address?> _getAddressByOpenstreetmap({
    required Position position,
    required String httpReferer,
    required String userAgent,
  }) async {
    log('Getting user\'s address by nominatim.openstreetmap.org');
    final String apiUrl =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Referer': httpReferer, // Replace with your application's URL
        'User-Agent': userAgent,
      },
    );

    if (response.statusCode == 200) {
      log('Requst succeeded!');

      final Map<String, dynamic> data = json.decode(response.body);

      log('Data recived from the API => $data');

      if (data['address'] != null) {
        final address = data['address'] as Map<String, dynamic>;
        if (data.isNotEmpty) {
          return Address.fromJson(address);
        }
      }
    } else {
      log('Cannot fetch data from API');
      log('STATUS CODE : ${response.statusCode}, Error : ${response.body}');
      throw Exception('Failed to get country from API');
    }
    return null;
  }

  static Future<Address?> _getAddressByGeocoder(
      double latitude, double longitude) async {
    log('Getting user\'s address by Geocoder');

    final List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      log('Geocoder was sucessfully found address');
      return Address.fromPlacemark(placemarks.first);
    }
    return null;
  }
}

List<String> _euCountries = [
  'AT', // Austria
  'BE', // Belgium
  'BG', // Bulgaria
  'CY', // Cyprus
  'CZ', // Czech Republic
  'DE', // Germany
  'DK', // Denmark
  'EE', // Estonia
  'EL', // Greece (Alternate code for Greece)
  'ES', // Spain
  'FI', // Finland
  'FR', // France
  'HR', // Croatia
  'HU', // Hungary
  'IE', // Ireland
  'IT', // Italy
  'LT', // Lithuania
  'LU', // Luxembourg
  'LV', // Latvia
  'MT', // Malta
  'NL', // Netherlands
  'PL', // Poland
  'PT', // Portugal
  'RO', // Romania
  'SE', // Sweden
  'SI', // Slovenia
  'SK', // Slovakia
];

// The above list contains ISO 3166-1 alpha-2 country codes.
// Please ensure this list is up-to-date with the current EU membership.
