import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/order_widget.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<Orders>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshOrders(context),
        child: FutureBuilder(
            future: Provider.of<Orders>(context, listen: false).loadOrders(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.error != null) {
                return Center(child: Text('Ocorreu um erro!'));
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orders, child) {
                    return ListView.builder(
                      itemCount: orders.ordersCount,
                      itemBuilder: (context, index) =>
                          OrderWidget(orders.orders[index]),
                    );
                  },
                );
              }
            }),
      ),
      drawer: AppDrawer(),
    );
  }
}
