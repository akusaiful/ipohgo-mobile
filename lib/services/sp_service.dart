import 'package:shared_preferences/shared_preferences.dart';

class SPService{

  Future setNotificationSubscription (bool value) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('n_subscribe', value);
  }

  Future<bool> getNotificationSubscription () async{
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool('n_subscribe') ?? true;
    return value;
  }
  
}