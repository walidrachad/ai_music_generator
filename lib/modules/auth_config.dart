class AuthConfig {
  String url;
  List<AuthCookies> cookies;

  AuthConfig({
    required this.url,
    required this.cookies,
  });

  factory AuthConfig.fromJson(Map<String, dynamic> data) {
    List<AuthCookies> cookies = [];
    data['cookies'].forEach((v) {
      cookies.add(AuthCookies.fromJson(v));
    });
    return AuthConfig(
      url: data["url"],
      cookies: cookies,
    );
  }
}

class AuthCookies {
  int index;
  String name;
  String value;

  AuthCookies({
    required this.index,
    required this.name,
    required this.value,
  });

  factory AuthCookies.fromJson(Map<dynamic, dynamic> data) {
    return AuthCookies(
      index: data["index"],
      name: data["name"],
      value: data["value"],
    );
  }
}
