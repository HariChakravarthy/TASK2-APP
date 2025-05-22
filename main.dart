import 'package:flutter/material.dart' ;
import 'package:my_first_app/pages/first_page.dart';

void main() {
  runApp(const HariApp()) ; // runApp is a defined Function
}

class HariApp extends StatelessWidget {
  const HariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'General Sans',
      ),
      debugShowCheckedModeBanner: false ,
      // home: HariFirstPage(),
      home: HariPasswordPage(),
    );
  }
}

