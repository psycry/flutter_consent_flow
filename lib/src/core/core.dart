import 'package:flutter/foundation.dart';
import 'package:flutter_consent_flow/src/core/services/regulatory_services.dart';
import 'package:flutter_consent_flow/src/core/services/global_services.dart';
import 'package:geolocator/geolocator.dart';

import 'enums/enums.dart';

/// A utility class for handling regulatory frameworks and geolocation permissions.
class FlutterConsentFlow {
  /// Initializes the Flutter Consent Flow library.
  ///
  /// This method must be called before using other functionalities of the library.
  ///
  /// - [httpReferer]: The HTTP referer to be used for API requests.
  /// - [userAgent]: The user agent to be used for API requests.
  /// - [enableLogs]: Whether to enable logs for debugging (default is true).
  static void initialize({
    required String httpReferer,
    required String userAgent,
    bool enableLogs = true,
  }) {
    GlobalServices.instance.initialize(
      httpReferer: httpReferer,
      userAgent: userAgent,
      enableLogs: enableLogs,
    );
  }

  /// Gets the regulatory framework based on IP address.
  ///
  /// This method retrieves the regulatory framework based on the user's IP address.
  ///
  /// - [apiKey]: `ipgeolocation.io` API key for making requests.
  ///   You can obtain an API key from https://ipgeolocation.io to use this service.
  /// - [ifFailed]: A callback to be executed if the regulatory check fails.
  /// - [mockIP]: A mock IP address for testing purposes (optional).
  static Future<RegulatoryFramework?> getRegulatoryFrameworkByIP({
    required String apiKey,
    VoidCallback? ifFailed,
    String? mockIP,
  }) async {
    return RegulatoryServices.checkRegulatoryFrameworkByIP(
      ifFailed: ifFailed,
      apiKey: apiKey,
      mockIP: mockIP,
    );
  }

  /// Gets the regulatory framework based on coordinates.
  ///
  /// This method retrieves the regulatory framework based on the user's device coordinates.
  ///
  /// - [ifFailed]: A callback to be executed if the regulatory check fails.
  /// - [useGeocoderIfFails]: Whether to use geocoder if coordinates-based `nominatim.openstreetmap.org` api request fails.
  ///   WARNING: Using the geocoder API as a fallback is NOT RECOMMENDED BY GOOGLE.
  ///   For more information, refer to the official documentation:
  ///   https://developer.android.com/reference/android/location/Geocoder
  static Future<RegulatoryFramework?> getRegulatoryFrameworkByCoordinates({
    VoidCallback? ifFailed,
    bool useGeocoderIfFails = false,
  }) async {
    return RegulatoryServices.checkRegulatoryFrameworkByCoordinates(
      ifFailed: ifFailed,
      useGeocoderIfFails: useGeocoderIfFails,
    );
  }

  /// Checks the location permission.
  ///
  /// This method checks the geolocation permission status on the device.
  ///
  /// Returns the current location permission status.
  static Future<LocationPermission> checkPermissions() async {
    return Geolocator.checkPermission();
  }

  /// Requests location permission.
  ///
  /// This method requests geolocation permission from the user.
  ///
  /// Returns the updated location permission status.
  static Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }
}
