import 'dart:async';
import 'dart:convert';

import 'package:pasiguro_mobile_app/models/item_model.dart';
import 'package:http/http.dart' as http;

const hostName = 'https://pasiguro-api.herokuapp.com';
const path = '/api/v1/items';

abstract class ItemService {
  Future<bool> createItem(ItemModel item);
  Future<List<ItemModel>> getItems();
  Future<bool> updateItem(ItemModel item);
  Future<bool> deleteItem(int id);
}

class ItemServiceImpl implements ItemService {
  @override
  Future<bool> createItem(ItemModel item) async {
    final client = http.Client();
    final uri = Uri.parse('$hostName$path');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(item.toMap());

    final response = await client.post(uri, headers: headers, body: body);

    if (response.statusCode != 200) return false;

    return true;
  }

  @override
  Future<List<ItemModel>> getItems() async {
    final client = http.Client();
    final uri = Uri.parse('$hostName$path');

    final response = await client.get(uri);
    if (response.statusCode != 200) return [];

    final List items = json.decode(response.body);

    return items.isEmpty ? [] : items.map((a) => ItemModel.fromMap(a)).toList();
  }

  @override
  Future<bool> updateItem(ItemModel item) async {
    final client = http.Client();
    final uri = Uri.parse('$hostName$path/${item.id}');
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(item.toMap());

    final response = await client.put(uri, headers: headers, body: body);

    if (response.statusCode != 200) return false;

    return true;
  }

  @override
  Future<bool> deleteItem(int id) async {
    final client = http.Client();
    final uri = Uri.parse('$hostName$path/$id');
    final response = await client.delete(uri);

    if (response.statusCode != 200) return false;

    return true;
  }
}
