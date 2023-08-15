class GlobalServices {
  static final instance = GlobalServices._();

  GlobalServices._();

  String? httpReferer;
  String? userAgent;
  bool enableLogs = true;

  void initialize({
    String? httpReferer,
    String? userAgent,
    bool enableLogs = true,
  }) {
    this.httpReferer = httpReferer;
    this.userAgent = userAgent;
    this.enableLogs = enableLogs;
  }
}
