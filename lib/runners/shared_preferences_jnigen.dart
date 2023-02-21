import 'package:hive_benchmark/runners/runner.dart';
import 'package:hive_benchmark/shared_preferences_jnigen.dart';
import 'package:jni/jni.dart';

class SharedPreferencesJnigenRunner implements BenchmarkRunner {
  late SharedPreferences prefs;
  late SharedPreferences_Editor editor;

  @override
  String get name => 'Shared Preferences (jnigen)';

  @override
  Future<void> setUp() async {
    final context = Context.fromRef(Jni.getCachedApplicationContext());
    prefs = context.getSharedPreferences(
      JString.fromString('FlutterSharedPreferences'),
      Context.MODE_PRIVATE,
    );
    editor = prefs.edit();
    editor.clear();
  }

  @override
  Future<void> tearDown() async {
    editor.delete();
    prefs.delete();
  }

  @override
  Future<int> batchReadInt(List<String> keys) async {
    List<JString> jKeys = keys.map((e) => e.toJString()).toList();
    var s = Stopwatch()..start();
    for (var key in jKeys) {
      prefs.getInt(key, 0);
    }
    s.stop();
    return s.elapsedMilliseconds;
  }

  @override
  Future<int> batchReadString(List<String> keys) async {
    List<JString> jKeys = keys.map((e) => e.toJString()).toList();
    final defaultString = "".toJString();
    var s = Stopwatch()..start();
    for (var key in jKeys) {
      prefs.getString(key, defaultString);
    }
    s.stop();
    return s.elapsedMilliseconds;
  }

  @override
  Future<int> batchWriteInt(Map<String, int> entries) async {
    var s = Stopwatch()..start();
    for (var key in entries.keys) {
      editor.putInt(key.toJString(), entries[key]!);
    }
    editor.commit();
    s.stop();
    return s.elapsedMilliseconds;
  }

  @override
  Future<int> batchWriteString(Map<String, String> entries) async {
    var s = Stopwatch()..start();
    for (var key in entries.keys) {
      editor.putString(key.toJString(), entries[key]!.toJString());
    }
    editor.commit();
    s.stop();
    return s.elapsedMilliseconds;
  }

  @override
  Future<int> batchDeleteInt(List<String> keys) async {
    var s = Stopwatch()..start();
    for (var key in keys) {
      editor.remove(key.toJString());
    }
    editor.commit();
    s.stop();
    return s.elapsedMilliseconds;
  }

  @override
  Future<int> batchDeleteString(List<String> keys) {
    return batchDeleteInt(keys);
  }
}
