import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/app_backend_api.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import 'cart.dart';

class Orders with ChangeNotifier {
  final String _url = AppBackendApi.END_POINT_ORDERS;
  List<Order> _orders = [];
  String _token;
  String _userId;

  Orders([this._token, this._userId, this._orders = const []]);

  List<Order> get orders {
    return [..._orders];
  }

  int get ordersCount {
    return _orders.length;
  }

  Future<void> loadOrders() async {
    List<Order> loadedOrders = [];
    
    final response = await http.get("$_url/$_userId.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);

    if (data != null) {
      data.forEach((orderId, orderData) {
        loadedOrders.add(Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              price: item['price'],
              productId: item['productId'],
              quantity: item['quantity'],
              title: item['title'], 
            );
          }).toList(),
          total: orderData['total'],
        ));
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      "$_url/$_userId.json?auth=$_token",
      body: json.encode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }
}
