import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../providers/products.dart';

class AppProviders {
  static List<SingleChildWidget> providers() {
    return [
      ChangeNotifierProvider(
        create: (_) => new Auth(),
      ),
      ChangeNotifierProxyProvider<Auth, Products>(
        create: (_) => new Products(),
        update: (context, auth, previousProducts) => new Products(
          auth.token,
          auth.userId,
          previousProducts.items,
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => new Cart(),
      ),
      ChangeNotifierProxyProvider<Auth, Orders>(
        create: (_) => new Orders(),
        update: (context, auth, previousOrders) => new Orders(
          auth.token,
          auth.userId,
          previousOrders.orders,
        ),
      ),
    ];
  }
}
