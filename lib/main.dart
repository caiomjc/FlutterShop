import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './utils/app_providers.dart';
import './utils/app_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers(),
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        routes: AppRoutes.routes(),
      ),
    );
  }
}
