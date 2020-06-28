import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../utils/app_backend_api.dart';
import '../models/product.dart';

class Products with ChangeNotifier {
  final String _urlProducts = AppBackendApi.END_POINT_PRODUCTS;
  final String _urlFavorites = AppBackendApi.END_POINT_FAVORITES;
  List<Product> _items = [];
  String _token;
  String _userId;

  Products([this._token, this._userId, this._items = const []]);

  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  int get productsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    final response = await http.get("$_urlProducts.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);

    final favoritesResponse = await http.get("$_urlFavorites/$_userId.json?auth=$_token");
    final favoritesMap = json.decode(favoritesResponse.body);
    
    

    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        final isFavorite = favoritesMap == null ? false : favoritesMap[productId] ?? false;
        
        _items.add(Product(
          id: productId,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ));
      });

      notifyListeners();
    }

    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    final response = await http.post(
      "$_urlProducts.json?auth=$_token",
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl
      }),
    );

    _items.add(Product(
      id: json.decode(response.body)['name'],
      title: newProduct.title,
      price: newProduct.price,
      description: newProduct.description,
      imageUrl: newProduct.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch(
        "$_urlProducts/${product.id}.json?auth=$_token",
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> changeFavoriteStatus(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    product.toggleFavorite();

    try {
      
      print ("$_urlFavorites/$_userId/${product.id}.json?auth=$_token");
      
      await http.put(
        "$_urlFavorites/$_userId/${product.id}.json?auth=$_token",
        body: json.encode(product.isFavorite),
      );
    } catch (error) {
      product.toggleFavorite();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      final product = _items[index];

      _items.remove(product);
      notifyListeners();

      final response =
          await http.delete("$_urlProducts/${product.id}.json?auth=$_token");

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ócorreu um erro na exclusão do produto.');
      }
    }
  }
}
