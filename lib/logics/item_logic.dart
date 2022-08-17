import 'package:pasiguro_mobile_app/models/item_model.dart';
import 'package:pasiguro_mobile_app/services/item_service.dart';
import 'package:quiver/cache.dart' show MapCache;

abstract class ItemLogic {
  Future<bool> createItem(ItemModel item);
  Future<List<ItemModel>> getItems({bool fresh = false});
  Future<bool> updateItem(ItemModel item);
  Future<bool> deleteItem(int id);
}

class ItemLogicImpl implements ItemLogic {
  final ItemService _itemService;

  final MapCache _cache;

  ItemLogicImpl(
    this._itemService,
  ) : _cache = MapCache.lru(maximumSize: 30);

  @override
  Future<bool> createItem(ItemModel item) async {
    final result = await _itemService.createItem(item);

    if (result) {
      await _cache.set('isItemsListUpdated', false);
    }

    return result;
  }

  @override
  Future<List<ItemModel>> getItems({bool fresh = false}) async {
    if (!fresh) {
      print('🔔 Fetched items from cache.');
      return await _cache.get('latestItemsList');
    }

    final bool isItemsListUpdated =
        await _cache.get('isItemsListUpdated') ?? false;

    if (isItemsListUpdated) {
      print('🔔 Fetched items from cache.');

      return await _cache.get('latestItemsList');
    }

    final itemsList = await _itemService.getItems();
    print('🔔 Fetched fresh items.');

    await _cache.set('latestItemsList', itemsList);
    await _cache.set('isItemsListUpdated', true);

    return itemsList;
  }

  @override
  Future<bool> updateItem(ItemModel item) async {
    final result = await _itemService.updateItem(item);

    if (result) {
      await _cache.set('isItemsListUpdated', false);
    }

    return result;
  }

  @override
  Future<bool> deleteItem(int id) async {
    final result = await _itemService.deleteItem(id);

    if (result) {
      await _cache.set('isItemsListUpdated', false);
    }

    return result;
  }
}
