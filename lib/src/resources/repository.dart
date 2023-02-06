import '../models/item_model.dart';
import 'dart:async';
import 'news_db_provider.dart';
import 'news_api_provider.dart';

NewsDbProvider newsDbProvider = NewsDbProvider();
NewsApiProvider newsApiProvider = NewsApiProvider();

class Repository {
  List<Source> sources = <Source>[
    newsDbProvider,
    newsApiProvider,
  ];

  List<Cache> caches = <Cache>[newsDbProvider];

  fetchTopIds() async {
    List<int> topIds;
    for (Source source in sources) {
      topIds = await source.fetchTopIds();
      if (topIds.isNotEmpty) return topIds;
    }
  }

  Future<ItemModel?> fetchItem(int id) async {
    ItemModel? item;
    var source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) break;
    }

    if (item == null) return null;

    for (Cache cache in caches) {
      if (cache != source) {
        cache.addItem(item);
      }
    }

    return item;
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  FutureOr<ItemModel?> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
}
