/// Backend base URL.
///
/// Defaults to `http://localhost:3000`, which works when running the app
/// as a **web** build (`flutter run -d chrome`) or a **desktop** build
/// against a backend running on the same machine.
///
/// If you're running on an emulator/device instead, override this at build
/// time, e.g.:
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000   # Android emulator
///   flutter run --dart-define=API_BASE_URL=http://192.168.1.23:3000 # physical device on same Wi-Fi
///
/// (iOS Simulator can use http://localhost:3000 same as web/desktop.)
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}
