import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:news/src/resources/repository.dart';
import '../models/item_model.dart';

class NewsApiProvider implements Source {
  Client client = Client();
  final String _endpoint = "https://hacker-news.firebaseio.com/v0";

  @override
  Future<List<int>> fetchTopIds() async {
    String url = "$_endpoint/topstories.json";
    final response = await client.get(Uri.parse(url));
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    String url = "$_endpoint/item/$id.json";
    final response = await client.get(Uri.parse(url));
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJson(parsedJson);
  }
}
