import 'package:flutter/material.dart';
import 'views/mainView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey)
      ),
      debugShowCheckedModeBanner: false,
      home: const MainView(),
    );
  }
}
