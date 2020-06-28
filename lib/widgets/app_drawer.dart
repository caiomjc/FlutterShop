import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: const Text('Bem vindo Usuário'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: const Icon(Icons.shop),
          title: const Text('Loja'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_HOME);
          },
        ),
        Divider(),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text('Pedidos'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.ORDERS);
          },
        ),
        Divider(),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Gerenciar Produtos'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.PRODUCTS);
          },
        ),
        Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Sair'),
          onTap: () {
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ],
    ));
  }
}
