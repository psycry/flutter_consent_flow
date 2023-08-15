class GlobalServices {
  static final instance = GlobalServices._();

  GlobalServices._();

  late String httpReferer;
  late String userAgent;
  bool enableLogs = true;

  void initialize({
    required String httpReferer,
    required String userAgent,
    bool enableLogs = true,
  }) {
    this.httpReferer = httpReferer;
    this.userAgent = userAgent;
    this.enableLogs = enableLogs;
  }
}
