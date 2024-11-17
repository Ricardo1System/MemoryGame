

import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
    static late SharedPreferences sharedPreferences;

    static init() async {
      sharedPreferences =  await SharedPreferences.getInstance();
    }

    static String getString({required String key}){
      return sharedPreferences.getString(key) ?? "";
    }
    static int getInteger({required String key}){
      return sharedPreferences.getInt(key) ?? 0;
    }
    static String getBool({required String key}){
      return sharedPreferences.getString(key) ?? "";
    }
    
    static List<String> getStringList({required String key}){
      return sharedPreferences.getStringList(key) ?? [];
    }

    static saveData({required String key, required dynamic value}) async {
      if (value is String) {
        return await sharedPreferences.setString(key, value);
      }else if(value is int){
        return await sharedPreferences.setInt(key, value);
      }else if(value is double){
        return await sharedPreferences.setDouble(key, value);
      }if (value is bool) {
        return await sharedPreferences.setBool(key, value);
      }else{
        return await sharedPreferences.setStringList(key, value);
      }
    }
}