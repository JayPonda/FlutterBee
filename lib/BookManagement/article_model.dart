import 'summery.dart';
import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';

class ArticleModel {
  Future<Summary> getRandomArticleSummary() async {
    final uri = Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',
    );
    final response = await get(uri);

    if (response.statusCode != 200) {
      throw HttpException('Failed to update resource');
    }

    return Summary.fromJson(jsonDecode(response.body));
  }
}
