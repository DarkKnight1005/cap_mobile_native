// import 'package:shared_preferences/shared_preferences.dart';

// class KeyValueService {
//   static Future clear() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }

//   static Future saveV(key, value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     if (value is int) {
//       prefs.setInt(key, value);
//     } else if (value is double) {
//       prefs.setDouble(key, value);
//     } else if (value is String) {
//       prefs.setString(key, value);
//     } else if (value is bool) {
//       prefs.setBool(key, value);
//     }
//   }

//   static Future<String> getV(key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     try {
//       return prefs.get(key).toString();
//     } catch (e) {
//       return null;
//     }
//   }

//   static deleteK(key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove(key);
//   }
// }
