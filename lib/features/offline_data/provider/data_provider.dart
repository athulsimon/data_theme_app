import 'package:data_theme_app/features/offline_data/services/data_services.dart';
import 'package:data_theme_app/features/offline_data/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final dataProvider = FutureProvider<List<Post>>((ref) async {
  final box = Hive.box('localData');
  final connectivity = await Connectivity().checkConnectivity();
  bool isOffline = connectivity == ConnectivityResult.none;

  try {
    if (!isOffline) {
      final posts = await DataService.fetchPosts();
      await box.put('posts', posts.map((e) => e.toJson()).toList());
      return posts;
    } else {
      final cached = box.get('posts');
      if (cached != null) {
        return (cached as List)
            .map((e) => Post.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    }
  } catch (_) {
    final cached = box.get('posts');
    if (cached != null) {
      return (cached as List)
          .map((e) => Post.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
  }

  return [];
});