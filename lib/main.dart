import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'bottom_navigation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: bottomNavigation(0),
    );
  }
}

