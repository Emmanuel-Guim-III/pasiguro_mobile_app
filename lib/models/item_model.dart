import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemModel {
  final int? id;
  final String name;
  final String price;
  final String type;
  final String quantity;
  final String store;
  final DateTime dateOfPurchase;
  final DateTime inventoryDateTime;

  const ItemModel({
    this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.quantity,
    required this.store,
    required this.dateOfPurchase,
    required this.inventoryDateTime,
  });

  factory ItemModel.fromMap(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toString(),
      type: json['type'],
      quantity: json['quantity'],
      store: json['store'],
      dateOfPurchase: DateTime.parse(json['date_of_purchase']),
      inventoryDateTime: DateTime.parse(json['inventory_date_time']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'type': type,
      'quantity': quantity,
      'store': store,
      'date_of_purchase': dateOfPurchase.toIso8601String(),
      'inventory_date_time': inventoryDateTime.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '''
      Appointment{
        id: $id, 
        name: $name, 
        price: $price, 
        type: $type, 
        quantity: $quantity, 
        store: $store, 
        dateOfPurchase: $dateOfPurchase, 
        inventoryDateTime: $inventoryDateTime
      }
    ''';
  }

  ItemResult formatProps(BuildContext context) {
    return ItemResult(
      id: id.toString(),
      name: name,
      price: double.parse(price).toStringAsFixed(2),
      type: type,
      quantity: quantity,
      store: store,
      dateOfPurchase: DateFormat('MMM dd, yyyy').format(dateOfPurchase),
      inventoryDateTime:
          DateFormat('MMM dd, yyyy  hh:mm aaa').format(inventoryDateTime),
    );
  }
}

class ItemResult {
  final String id;
  final String name;
  final String price;
  final String type;
  final String quantity;
  final String store;
  final String dateOfPurchase;
  final String inventoryDateTime;

  const ItemResult({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.quantity,
    required this.store,
    required this.dateOfPurchase,
    required this.inventoryDateTime,
  });
}
