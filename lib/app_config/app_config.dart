import 'package:http/http.dart' as http;

class AppConfig {
  static final String appName = 'ShareWorld';
  static final String packageName = '<package_name>';
  static final String languageDefault = "en";
  static final Map<String, String> languagesSupported = {
    'en': "English",
    'ar': "عربى",
    'pt': "Portugal",
    'fr': "Français",
    'id': "Bahasa Indonesia",
    'es': "Español",
  };

  static final String apiUrl = 'http://dev.eyad-web-development.com/api/';

  static final String profilePicturesUrl = 'http://dev.eyad-web-development.com/storage/users/';

  static final String postsPicturesUrl = 'http://dev.eyad-web-development.com/storage/posts/';
}

extension IsOk on http.Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}

extension IsOk2 on http.StreamedResponse {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}
