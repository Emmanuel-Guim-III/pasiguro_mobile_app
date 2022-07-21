import 'dart:async';
import 'dart:convert';

import 'package:pasiguro_mobile_app/models/item_model.dart';
import 'package:http/http.dart' as http;

const hostName = 'https://pasiguro-api.herokuapp.com';

abstract class ItemService {
  Future<int> createItem(ItemModel item);
  Future<List<ItemModel>> getItems();
  Future<int> updateItem(ItemModel item);
  Future<int> deleteItem(int id);
}

class ItemServiceImpl implements ItemService {
  @override
  Future<int> createItem(ItemModel item) async {
    final client = http.Client();
    final uri = Uri.parse('$hostName/items');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(item.toMap());

    final response = await client.post(uri, headers: headers, body: body);

    if (response.statusCode != 200) return 0;

    return 1;
  }

  @override
  Future<List<ItemModel>> getItems() async {
    final client = http.Client();
    final uri = Uri.parse('$hostName/items');

    final response = await client.get(uri);
    if (response.statusCode != 200) return [];

    final List items = json.decode(response.body);

    return items.isEmpty ? [] : items.map((a) => ItemModel.fromMap(a)).toList();
  }

  @override
  Future<int> updateItem(ItemModel item) async {
    final client = http.Client();
    final uri = Uri.parse('$hostName/items/${item.id}');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(item.toMap());

    final response = await client.put(uri, headers: headers, body: body);

    if (response.statusCode != 200) return 0;

    return 1;
  }

  @override
  Future<int> deleteItem(int id) async {
    final client = http.Client();
    final uri = Uri.parse('$hostName/items/$id');
    final response = await client.delete(uri);

    if (response.statusCode != 200) return 0;

    return 1;
  }
}
