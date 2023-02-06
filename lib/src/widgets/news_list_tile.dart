import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
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
          return const LoadingContainer();
        }

        return FutureBuilder(
          future: snapshot.data![itemId],
          builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
            if (itemSnapshot.hasData == false) {
              return const LoadingContainer();
            }

            return Column(
              children: [
                buildTile(itemSnapshot.data!),
                const Divider(),
              ],
            );
          },
        );
      }),
    );
  }

  Widget buildTile(ItemModel item) {
    return ListTile(
      title: Text(item.title!),
      subtitle: Text("${item.score.toString()} points"),
      trailing: Column(
        children: [
          const Icon(Icons.comment),
          Text("${item.descendants}"),
        ],
      ),
    );
  }
}
