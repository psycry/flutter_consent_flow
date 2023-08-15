class HttpHeadersMissing implements Exception {
  @override
  String toString() =>
      'Seems to be you\'ve not provided `httpReferer` or `userAgent` headers to the request. Make sure you call `FlutterConsentFlow.initialize` with header arguments before trying to use `checkRegulatoryFrameworkByCoordinates` method.';
}
