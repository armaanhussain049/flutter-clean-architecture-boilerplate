/// Configuration for the application
abstract class AppConfig {
  String get baseUrl;
  String get apiKey;
  bool get enableLogging;
  int get postsPerPage;
}

/// Development configuration
class DevConfig implements AppConfig {
  @override
  String get baseUrl => 'https://jsonplaceholder.typicode.com';

  @override
  String get apiKey => 'dev_api_key';

  @override
  bool get enableLogging => true;

  @override
  int get postsPerPage => 10;
}

/// Production configuration
class ProdConfig implements AppConfig {
  @override
  String get baseUrl => 'https://api.example.com';

  @override
  String get apiKey => 'prod_api_key';

  @override
  bool get enableLogging => false;

  @override
  int get postsPerPage => 20;
}

/// Flavor enum
enum Flavor { dev, prod }

/// Current flavor (can be set based on environment)
Flavor currentFlavor = Flavor.dev;

/// Get current config based on flavor
AppConfig get appConfig {
  switch (currentFlavor) {
    case Flavor.dev:
      return DevConfig();
    case Flavor.prod:
      return ProdConfig();
  }
}