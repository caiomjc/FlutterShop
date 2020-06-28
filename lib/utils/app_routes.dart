import 'package:flutter/material.dart';

import '../views/auth_home.dart';
import '../views/cart_screen.dart';
import '../views/orders_screen.dart';
import '../views/products_screen.dart';
import '../views/product_detail_screen.dart';
import '../views/product_form_screen.dart';

class AppRoutes {
  static const AUTH_HOME = '/';
  static const PRODUCT_DETAIL = '/product-detail';
  static const CART = '/cart';
  static const ORDERS = '/orders';
  static const PRODUCTS = '/products';
  static const PRODUCT_FORM = '/product-form';

  static Map<String, WidgetBuilder> routes() {
    return <String, WidgetBuilder>{
      AUTH_HOME: (context) => AuthOrHome(),
      PRODUCT_DETAIL: (context) => ProductDetailScreen(),
      CART: (context) => CartScreen(),
      ORDERS: (context) => OrdersScreen(),
      PRODUCTS: (context) => ProductsScreen(),
      PRODUCT_FORM: (context) => ProductFormScreen(),
    };
  }
}
