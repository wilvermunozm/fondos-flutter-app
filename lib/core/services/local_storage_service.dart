import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static const String subscriptionIdsKey = 'subscription_ids';
  

  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;
  

  LocalStorageService._();
  

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }
  

  List<String> getSubscriptionIds() {
    final String? idsJson = _preferences?.getString(subscriptionIdsKey);
    if (idsJson == null) {
      return [];
    }
    
    try {
      final List<dynamic> decoded = json.decode(idsJson);
      return decoded.map((id) => id.toString()).toList();
    } catch (e) {
      return [];
    }
  }
  

  Future<bool> saveSubscriptionIds(List<String> ids) async {
    return await _preferences?.setString(subscriptionIdsKey, json.encode(ids)) ?? false;
  }
  

  Future<bool> addSubscriptionId(String id) async {
    final List<String> currentIds = getSubscriptionIds();
    if (!currentIds.contains(id)) {
      currentIds.add(id);
      return await saveSubscriptionIds(currentIds);
    }
    return true;
  }
  

  Future<bool> removeSubscriptionId(String id) async {
    final List<String> currentIds = getSubscriptionIds();
    if (currentIds.contains(id)) {
      currentIds.remove(id);
      return await saveSubscriptionIds(currentIds);
    }
    return true;
  }
  

  Future<bool> clearSubscriptionIds() async {
    return await _preferences?.remove(subscriptionIdsKey) ?? false;
  }
}
