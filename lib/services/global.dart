part of "package:baso/baso.dart";

// Global service
class GenericGlobalService {
  static bool _initialized = false;

  // Welcomed
  static set welcomed(bool value) => preferences.setBool("welcomed", value);
  static bool get welcomed => preferences.getBool("welcomed") ?? false;

  // Preference getting
  static bool? getBool(String key) => preferences.getBool(key);
  static double? getDouble(String key) => preferences.getDouble(key);
  static int? getInt(String key) => preferences.getInt(key);
  static String? getString(String key) => preferences.getString(key);
  static List<String>? getStringList(String key) =>
      preferences.getStringList(key);
  static Map? getMap(String key) {
    String? encodedString = preferences.getString(key);

    if (encodedString == null) {
      return null;
    }

    return jsonDecode(encodedString) as Map?;
  }

  // Preference setting
  static Future<bool> setBool(String key, bool value) =>
      preferences.setBool(key, value);
  static Future<bool> setDouble(String key, double value) =>
      preferences.setDouble(key, value);
  static Future<bool> setInt(String key, int value) =>
      preferences.setInt(key, value);
  static Future<bool> setString(String key, String value) =>
      preferences.setString(key, value);
  static Future<bool> setStringList(String key, List<String> value) =>
      preferences.setStringList(key, value);
  static Future<bool> setMap(String key, Map? value) {
    return preferences.setString(key, jsonEncode(value));
  }

  // Welcomed
  static set accepted(bool value) => preferences.setBool("accepted", value);
  static bool get accepted => preferences.getBool("accepted") ?? false;

  // Blocked
  static set blocked(bool value) => preferences.setBool("blocked", value);
  static bool get blocked => preferences.getBool("blocked") ?? false;

  // Authenticated
  static set authenticated(bool value) {
    preferences.setBool("authenticated", value);
    authenticationNotifier.value = value;
  }

  static bool get authenticated =>
      preferences.getBool("authenticated") ?? false;

  // Preferences
  static late SharedPreferences preferences;

  // Zone
  static String? zone;

  // Web
  static bool web = kIsWeb;

  // State
  static set state(String value) => setString("state", value);
  static String get state => getString("state") ?? "";

  // Token
  static set token(String value) => setString("token", value);
  static String get token => getString("token") ?? "";

  // Uid
  static set uid(String value) => setString("uid", value);
  static String get uid => getString("uid") ?? "";

  // Display name
  static set displayName(String value) => setString("display_name", value);
  static String get displayName => getString("display_name") ?? "";

  // Phone number
  static set phoneNumber(String value) => setString("phone_number", value);
  static String get phoneNumber => getString("phone_number") ?? "";

  // Photo URL
  static set photoURL(String value) => setString("photo_url", value);
  static String get photoURL => getString("photo_url") ?? "";

  // Call
  static set call(Map? value) => setMap("call", value);
  static Map? get call => getMap("call");

  // Notifier
  static ValueNotifier<bool> authenticationNotifier =
      ValueNotifier<bool>(authenticated);

  // Init preferences
  static Future<void> init() async {
    if (!_initialized) {
      preferences = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  static void reset() {
    GenericGlobalService.welcomed = false;
    GenericGlobalService.authenticated = false;
    GenericGlobalService.accepted = false;
  }
}
