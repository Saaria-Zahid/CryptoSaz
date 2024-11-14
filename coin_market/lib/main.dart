
import 'package:coin_market/coin_list.dart';
import 'package:coin_market/theme_styling/colorStyle.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(

    theme: darkTheme,

      debugShowCheckedModeBanner: false,
      home:const Home(),
    );
  }
}


