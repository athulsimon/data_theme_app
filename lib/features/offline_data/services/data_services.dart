import 'dart:convert';
import 'package:data_theme_app/features/offline_data/models/post_model.dart';
import 'package:http/http.dart' as http;

class DataService {
  static const _url = 'https://jsonplaceholder.typicode.com/posts';

  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch posts');
    }
  }
}