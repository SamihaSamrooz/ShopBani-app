import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userIDKey = "USERIDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailkey = "USEREMAILKEY";
  static String userProfilekey = "USERPROFILEKEY";

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIDKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailkey, getUserEmail);
  }

  Future<bool> saveUserProfile(String getUserProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userProfilekey, getUserProfile);
  }

  Future<String?> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIDKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailkey);
  }

  Future<String?> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userProfilekey);
  }

  Future<void> clearPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // to remove stored data
  }
}
