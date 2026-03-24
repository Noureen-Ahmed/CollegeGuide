import 'package:shared_preferences/shared_preferences.dart';

/// Simple service to handle all data storage
class StorageService {
  // Keys for storing data
  static const String keyName = 'user_name';
  static const String keyEmail = 'user_email';
  static const String keyPassword = 'user_password';
  static const String keyIsVerified = 'is_verified';
  static const String keySelectedCourses = 'selected_courses';
  
  /// Helper to check if email belongs to a doctor 
  /// (Starts with 2 or more letters. 0 or 1 letter is considered a student/passport ID)
  static bool isDoctorEmail(String email) {
    final username = email.contains('@') ? email.split('@')[0] : email;
    return RegExp(r'^[a-zA-Z]{2,}').hasMatch(username);
  }
  
  // Initialize SharedPreferences
  static Future<void> init() async {
    await SharedPreferences.getInstance();
    print('[v0] StorageService initialized');
  }

  /// Save user registration data
  static Future<bool> saveUserData({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!email.endsWith('@gmail.com')) {
      print('[v0] StorageService Error: Email must end with @gmail.com');
      return false;
    }
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(keyName, name);
      await prefs.setString(keyEmail, email);
      await prefs.setString(keyPassword, password);
      await prefs.setBool(keyIsVerified, false);

      // Verify data was saved
      final savedEmail = prefs.getString(keyEmail);
      final savedPassword = prefs.getString(keyPassword);

      print('[v0] StorageService - Data Saved:');
      print('[v0] Name: $name');
      print('[v0] Email: $savedEmail');
      print('[v0] Password exists: ${savedPassword != null}');

      return savedEmail == email && savedPassword == password;
    } catch (e) {
      print('[v0] StorageService Error: $e');
      return false;
    }
  }

  /// Get user email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyEmail);
  }

  /// Get user password
  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyPassword);
  }

  /// Get user name
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyName);
  }

  /// Check if user is verified
  static Future<bool> isVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsVerified) ?? false;
  }

  /// Mark user as verified
  static Future<void> setVerified(bool verified) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsVerified, verified);
  }

  /// Save selected courses
  static Future<void> saveCourses(List<String> courseIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(keySelectedCourses, courseIds);
  }

  /// Get selected courses
  static Future<List<String>> getCourses() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keySelectedCourses) ?? [];
  }

  /// Check if user has account
  static Future<bool> hasAccount() async {
    final email = await getEmail();
    final password = await getPassword();
    return email != null && password != null;
  }



  /// Debug: Print all stored data
  static Future<void> debugPrintAll() async {
    final prefs = await SharedPreferences.getInstance();
    print('[v0] === STORED DATA ===');
    print('[v0] Name: ${prefs.getString(keyName)}');
    print('[v0] Email: ${prefs.getString(keyEmail)}');
    print('[v0] Password exists: ${prefs.getString(keyPassword) != null}');
    print('[v0] Is Verified: ${prefs.getBool(keyIsVerified)}');
    print('[v0] Courses: ${prefs.getStringList(keySelectedCourses)}');
    print('[v0] ==================');
  }


}
