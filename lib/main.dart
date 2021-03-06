import 'package:flutter/material.dart';
import 'initial_screen.dart';

void main() {
  runApp(InitialScreen());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bierfänger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InitialScreen(),
    );
  }
}