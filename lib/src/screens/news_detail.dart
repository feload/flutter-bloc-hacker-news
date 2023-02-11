import 'package:flutter/material.dart';
import '../blocs/comments_bloc.dart';
import '../blocs/comments_provider.dart';
import '../models/item_model.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;
  const NewsDetail({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details Page"),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
        if (snapshot.hasData == false) return const Text("Loading");

        final itemFuture = snapshot.data?[itemId];
        return FutureBuilder(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
            if (itemSnapshot.hasData == false) return Text("Loading $itemId");
            return buildList(itemSnapshot.data!, snapshot.data!);
          },
        );
      },
    );
  }

  Widget buildList(ItemModel? item, Map<int, Future<ItemModel?>> cache) {
    final children = <Widget>[];
    children.add(buildTitle(item));

    final commentsList = item?.kids?.map((kidId) {
          return Comment(
            itemId: kidId,
            cacheMap: cache,
            depth: 0,
          );
        }).toList() ??
        [];
    children.addAll(commentsList);

    return ListView(
      children: children,
    );
  }

  Widget buildTitle(item) {
    return Container(
      margin: const EdgeInsets.all(10),
      alignment: Alignment.topCenter,
      child: Text(
        item.title ?? "No title",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
