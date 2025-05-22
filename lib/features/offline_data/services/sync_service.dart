import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void startBackgroundSync() {
  Timer.periodic(const Duration(minutes: 5), (_) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      final box = Hive.box('localData');
      final cached = box.get('posts');
      if (cached != null) {
        await http.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          body: json.encode(cached),
          headers: {'Content-Type': 'application/json'},
        );
      }
    }
  });
}
