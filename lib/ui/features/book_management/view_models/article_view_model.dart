import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:basics/domain/models/article_model.dart';
import 'package:basics/domain/models/summary.dart';

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
      errorMessage = null;
    } on HttpException catch (error) {
      errorMessage = error.message;
      summary = null;
    }

    loading = false;
    notifyListeners();
  }
}
