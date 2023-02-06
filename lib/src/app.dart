import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'screens/news_list.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return StoriesProvider(
      child: const MaterialApp(
        title: "News",
        home: NewsList(),
      ),
    );
  }
}
