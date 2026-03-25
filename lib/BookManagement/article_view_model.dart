import 'dart:io';

import 'package:flutter/widgets.dart';
import 'article_model.dart';
import 'summery.dart';

class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  String? errorMessage;
  bool loading = false;

  ArticleViewModel(this.model) {
    getRandomArticleSummary();
  }

  Future<void> getRandomArticleSummary() async {
    loading = true;
    notifyListeners();

    try {
      summary = await model.getRandomArticleSummary();
      print('Article loaded: ${summary!.titles.normalized}'); // Temporary
      errorMessage = null;
    } on HttpException catch (error) {
      print('Error loading article: ${error.message}'); // Temporary
      errorMessage = error.message;
      summary = null;
    }

    loading = false;
    notifyListeners();
  }
}
