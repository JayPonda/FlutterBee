import 'package:basics/BookManagement/article_model.dart';
import 'package:basics/BookManagement/article_view_model.dart';
import 'package:flutter/material.dart';

import 'summery.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ArticleView());
  }
}

class ArticleView extends StatelessWidget {
  ArticleView({super.key});
  final viewModel = ArticleViewModel(ArticleModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wikipedia Flutter')),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return switch ((
            viewModel.loading,
            viewModel.summary,
            viewModel.errorMessage,
          )) {
            (true, _, _) => CircularProgressIndicator(),
            (false, _, String message) => Center(
              child: Text(message, style: TextStyle(color: Colors.red)),
            ),
            (false, null, null) => Center(
              child: Text(
                'An unknown error occured',
                style: TextStyle(color: Colors.blue.shade500),
              ),
            ),
            (false, Summary summary, null) => ArticlePage(
              summary: summary,
              nextArticleCallback: viewModel.getRandomArticleSummary,
            ),
          };
        },
      ),
    );
  }
}

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    required this.summary,
    required this.nextArticleCallback,
  });

  final Summary summary;
  final VoidCallback nextArticleCallback;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Generating random paragraphs can be an excellent way for writers to get their creative flow going at the beginning of the day. The writer has no idea what topic the random paragraph will be about when it appears. This forces the writer to use creativity to complete one of three common writing challenges. The writer can use the paragraph as the first one of a short story and build upon it. A second option is to use the random paragraph somewhere in a short story they create. The third option is to have the random paragraph be the ending paragraph in a short story. No matter which of these challenges is undertaken, the writer is forced to use creativity to incorporate the paragraph into their writing. Generating random paragraphs can be an excellent way for writers to get their creative flow going at the beginning of the day. The writer has no idea what topic the random paragraph will be about when it appears. This forces the writer to use creativity to complete one of three common writing challenges. The writer can use the paragraph as the first one of a short story and build upon it. A second option is to use the random paragraph somewhere in a short story they create. The third option is to have the random paragraph be the ending paragraph in a short story. No matter which of these challenges is undertaken, the writer is forced to use creativity to incorporate the paragraph into their writing.",
          ),
        ],
      ),
    );
  }
}
