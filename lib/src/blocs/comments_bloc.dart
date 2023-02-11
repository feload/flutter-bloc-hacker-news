import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:developer' as console;

class CommentsBloc {
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel?>>>();

  // Streams
  Stream<Map<int, Future<ItemModel?>>> get itemWithComments =>
      _commentsOutput.stream;

  // Sink
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  _commentsTransformer() {
    Map<int, Future<ItemModel?>> cache = {};
    return ScanStreamTransformer<int, Map<int, Future<ItemModel?>>>(
        (cacheMap, int id, iteration) {
      cacheMap[id] = _repository.fetchItem(id);
      cacheMap[id]?.then((ItemModel? item) {
        item?.kids?.forEach((kidId) => fetchItemWithComments(kidId));
      });
      return cacheMap;
    }, cache);
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
