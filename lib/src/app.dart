import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_provider.dart';
import 'package:news/src/screens/news_detail.dart';
import 'blocs/comments_provider.dart';
import 'screens/news_list.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: "News",
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == "/") {
      return MaterialPageRoute(builder: (context) {
        final bloc = StoriesProvider.of(context);
        bloc.fetchTopIds();

        return const NewsList();
      });
    }

    return MaterialPageRoute(builder: (context) {
      final itemId = int.parse(settings.name?.replaceFirst("/", "") ?? "");

      final commentsBloc = CommentsProvider.of(context);
      commentsBloc.fetchItemWithComments(itemId);

      return NewsDetail(
        itemId: itemId,
      );
    });
  }
}
