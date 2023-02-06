import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int? itemId;
  const NewsListTile({super.key, this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder:
          ((context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
        if (snapshot.hasData == false) {
          return Text("Stream still loading $itemId");
        }

        return FutureBuilder(
          future: snapshot.data![itemId],
          builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
            if (itemSnapshot.hasData == false) {
              return Text("ItemModel $itemId being loading...");
            }

            return Text(itemSnapshot.data!.title ?? "(?)");
          },
        );
      }),
    );
  }
}