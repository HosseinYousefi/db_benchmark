import 'package:hive_benchmark/jnigen_pref.dart';
import 'package:hive_benchmark/runners/runner.dart';
import 'package:jni/jni.dart';

class SharedPreferencesJnigenRunner implements BenchmarkRunner {
  late JnigenPref prefs;

  @override
  String get name => 'Shared Preferences (jnigen)';

  @override
  Future<void> setUp() async {
    prefs = JnigenPref.getInstance();
  }

  @override
  Future<void> tearDown() async {}

  @override
  Future<int> batchReadInt(List<String> keys) async {
    List<JString> jKeys = keys.map((e) => e.toJString()).toList();
    var s = Stopwatch()..start();
    for (var key in jKeys) {
      prefs.getInt(key);
    }
    s.stop();
    return s.elapsedMilliseconds;
  }

  @override
  Future<int> batchReadString(List<String> keys) async {
    List<JString> jKeys = keys.map((e) => e.toJString()).toList();
    var s = Stopwatch()..start();
    for (var key in jKeys) {
      prefs.getString(key);
    }
    s.stop();
    return s.elapsedMilliseconds;
  }

  @override
  Future<int> batchWriteInt(Map<String, int> entries) async {
    var s = Stopwatch()..start();
    for (var key in entries.keys) {
      prefs.setInt(key.toJString(), entries[key]!);
    }
    s.stop();
    return s.elapsedMilliseconds;
  }

  @override
  Future<int> batchWriteString(Map<String, String> entries) async {
    var s = Stopwatch()..start();
    for (var key in entries.keys) {
      prefs.setString(key.toJString(), entries[key]!.toJString());
    }
    s.stop();
    return s.elapsedMilliseconds;
  }

  // TODO
  @override
  Future<int> batchDeleteInt(List<String> keys) async {
    var s = Stopwatch()..start();
    // for (var key in keys) {
    //   editor.remove(key.toJString());
    // }
    // editor.commit();
    s.stop();
    return s.elapsedMilliseconds;
  }

  @override
  Future<int> batchDeleteString(List<String> keys) {
    return batchDeleteInt(keys);
  }
}
