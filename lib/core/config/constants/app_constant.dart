class AppConstant {
  static const String apiBaseUrl = "http://localhost:3000/api/v1";
  // static const String apiBaseUrl = "http://192.168.1.9:3000/api/v1";
  static const int timeoutDuration = 30;

  static const String appName = "Multi Catalog System";

  static const String regPhone =
      r'^(?:\+84|0084|0)(?:1|2|3|5|7|8|9)[0-9]{8,9}$';

  static const String regEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
}
