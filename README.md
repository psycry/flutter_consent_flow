
# Flutter Consent Flow ⚒
A Flutter utility library for handling regulatory frameworks and geolocation permissions. This library provides methods to identify the relevant regulatory framework based on the user's IP or location and show a consent dialog to request user consent.

## Getting Started 🚀

Add `flutter_consent_flow:1.0.0 ` to your `pubspec.yaml` file.
To use Flutter Consent Flow, you need to initialize the library first using the `initialize` method. This step is necessary before using other functionalities of the library.
```dart
FlutterConsentFlow.initialize(
	httpReferer:  'Your HTTP Referer',
	userAgent:  'Your User Agent',
	enableLogs:  true,  // Set to false to disable logs
);
```
- `httpReferer`: The HTTP referer to be used for API requests. You can use your website url or app's url for this.
- `userAgent`: The user agent to be used for API requests. You can pass some unique indentifer for your app.

## Regulatory Frameworks

The `RegulatoryFramework` enum provides a way to represent different regulatory frameworks related to user data protection and privacy laws. This enum is used as a return type for methods that determine the applicable regulatory framework based on the user's location.

### Enum Values  
- **`gdpr`**: Represents the European Union's General Data Protection Regulation (GDPR). This regulation aims to protect the personal data and privacy of EU citizens.
- **`ccpa`**: Represents the California Consumer Privacy Act (CCPA). This regulation grants California residents specific rights and control over their personal information. 
- **`lgpd`**: Represents Brazil's Lei Geral de Proteção de Dados (LGPD). This framework establishes rules for the collection, processing, and sharing of personal data in Brazil.
- **`notApplied`**: Indicates that none of the above regulatory frameworks are applicable or detected based on the user's location. 

These enum values allow you to easily identify and handle the relevant regulatory framework for your users. Depending on the framework detected, you can tailor your app's data usage and consent mechanisms accordingly.

### Identify Regulatory Framework
Flutter Consent Flow offers two methods to identify the regulatory framework applicable to the use

  1. IP Address-based Method: You can use the `getRegulatoryFrameworkByIP` method to identify the regulatory framework based on the user's IP address. This method requires an API key from ipgeolocation.io.
- [ipgeolocation API Documentation](https://ipgeolocation.io/documentation.html)
- [ipgeolocation Privacy Policy](https://ipgeolocation.io/privacy.html)

Example:
```dart
RegulatoryFramework? framework = await FlutterConsentFlow.getRegulatoryFrameworkByIP(
  apiKey: 'Your IPGeolocation.io API Key',
);
```
  
2. Coordinates-based Method: Use the `getRegulatoryFrameworkByCoordinates` method to identify the regulatory framework based on the user's device coordinates. This method also supports a fallback to the geocoder API, but using it as a fallback is NOT RECOMMENDED BY GOOGLE.
- [Nominatim API Documentation](https://nominatim.org/release-docs/latest/api/Overview/)

**IMPORTANT**:  You must attribute & follow [Nominatim Usage Policy](https://operations.osmfoundation.org/policies/nominatim/) in order to use their free APIs.

```dart
RegulatoryFramework? framework = await FlutterConsentFlow.getRegulatoryFrameworkByCoordinates();
```

**Note**: The accuracy and availability of the regulatory framework information may vary based on the chosen method.

  
#### Geolocation Permissions
If you choose to go with `checkRegulatoryFrameworkByCoordinates` method, you must check location permissions & handle permission states before use this method.
You can also use Flutter Consent Flow to check and request geolocation permissions on the user's device.

- `checkPermissions`: Check the current geolocation permission status.

```dart
final LocationPermission permission = await FlutterConsentFlow.checkPermissions();
```

- `requestPermission`: Request geolocation permission from the user.
```dart
LocationPermission permission = await FlutterConsentFlow.requestPermission();
```

**Note**: To find the coordinates of the user, we use [Geolocator](https://pub.dev/packages/geolocator) plugin inside `FlutterConsentFlow` package. You'll have to do platform specific configurations if you want to go with `getRegulatoryFrameworkByCoordinates` method. Follow [Geolocator](https://pub.dev/packages/geolocator) documentation to continue. 


## Showing the Consent Dialog

The `FlutterConsentFlow` package provides a built-in consent dialog that you can use to request user consent based on the detected regulatory framework. Before using this dialog, ensure that you have determined the applicable `RegulatoryFramework` using the package's methods.

### Using the Built-in Consent Dialog

To show the built-in consent dialog, follow these steps:

1. Determine the applicable regulatory framework using the package's methods.
2. Pass the result to the consent dialog as a parameter.

Here's an example of how to use the built-in consent dialog:

```dart
// Determine the applicable regulatory framework (e.g., GDPR)
RegulatoryFramework? framework = await FlutterConsentFlow.getRegulatoryFrameworkByIP(
  apiKey: 'Your IPGeolocation.io API Key',
);

// Show the consent dialog
final bool? userGrantedConsent = await showDialog<bool?>(
  context: context,
  builder: (_) => const FlutterConsentDialog(
    regulatoryFramework: RegulatoryFramework.gdpr,
    appIcon: AssetImage('assets/ic_launcher.png'),
    appName: 'Test App',
    privacyPolicyLink: 'https://www.testapp.com/privacy-policy/',
  ),
);
```
### Using a Custom Consent Dialog
If you prefer, you can design and use a custom consent dialog by incorporating your UI components. This gives you the flexibility to create a consent dialog that matches your app's design and branding.

To use a custom consent dialog, implement your own dialog and integrate it with the package's methods.

**Note**: Regardless of using the built-in or custom consent dialog, ensure that you follow the relevant regulatory framework's guidelines and provide users with clear and accurate information regarding data usage and consent options.
  
## Important Notices
- This package does not constitute legal advice or a legal entity. Users are responsible for managing their own data and ensuring compliance with relevant regulations.
- Flutter Consent Flow identifies geographical areas and relevant legal frameworks based on provided APIs. It does not guarantee accuracy or legal compliance.

## Contribution and Issues
Please feel free to contribute to this project by submitting pull requests or reporting issues. Your feedback is valuable in improving the library for all users.

## License
This library is open-source and released under the [MIT License](https://opensource.org/license/mit/).