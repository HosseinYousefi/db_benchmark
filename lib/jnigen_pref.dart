import 'package:hive_benchmark/shared_preferences_jnigen.dart' hide Map;
import 'package:jni/jni.dart';

class JnigenPref {
  final Map<JString, Object> _preferenceCache;
  final SharedPreferences _prefs;

  JnigenPref._(this._prefs, this._preferenceCache);

  static JnigenPref getInstance() {
    final cache = <JString, Object>{};
    final context = Context.fromRef(Jni.getCachedApplicationContext());
    final prefs = context.getSharedPreferences(
      JString.fromString('FlutterSharedPreferences'),
      Context.MODE_PRIVATE,
    );
    final map = prefs.getAll().castTo($MapType(JString.type, JObject.type));
    final keys = map.keySet().toArray();
    for (var i = 0; i < keys.length; ++i) {
      cache[keys[i].castTo(JString.type)] = map.get0(keys[i]);
    }
    return JnigenPref._(prefs, cache);
  }

  bool setInt(JString key, int value) {
    _preferenceCache[key] = value;
    return _prefs.edit().putInt(key, value).commit();
  }

  bool setString(JString key, JString value) {
    _preferenceCache[key] = value;
    return _prefs.edit().putString(key, value).commit();
  }

  int? getInt(JString key) {
    return _preferenceCache[key] as int?;
  }

  JString? getString(JString key) {
    return _preferenceCache[key] as JString?;
  }
}
