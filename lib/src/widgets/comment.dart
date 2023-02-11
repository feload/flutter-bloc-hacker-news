import 'package:flutter/material.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel?>> cacheMap;
  final int depth;
  const Comment({
    super.key,
    required this.itemId,
    required this.cacheMap,
    required this.depth,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cacheMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
        if (snapshot.hasData == false) return const LoadingContainer();

        final item = snapshot.data;
        final children = <Widget>[
          ListTile(
            contentPadding:
                EdgeInsets.only(left: 16.0 * (depth + 1), right: 16.0),
            title: buildText(item),
            subtitle: Text(item?.by ?? "No author"),
          ),
          const Divider()
        ];

        snapshot.data?.kids?.forEach((kidId) {
          children.add(
            Comment(
              itemId: kidId,
              cacheMap: cacheMap,
              depth: depth + 1,
            ),
          );
        });

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildText(ItemModel? item) {
    final text = item?.text
        ?.replaceAll("&#x27", "'")
        .replaceAll("&#x2F", "/")
        .replaceAll("&gt;", "")
        .replaceAll("<p>", "")
        .replaceAll("</p>", "");
    return Text(text ?? "");
  }
}
