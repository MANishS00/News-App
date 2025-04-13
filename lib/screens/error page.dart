import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_articles_app/screens/Home%20Screen.dart';

class errorpage extends StatefulWidget {
  const errorpage({super.key});

  @override
  State<errorpage> createState() => _errorpageState();
}

class _errorpageState extends State<errorpage> {

  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 55),
          child: Center(
            child: Image.asset(
              "assets/logo/error.png",
              height: 200,
            ),
          ),
        ),
        Text(
          "Hello I am Error",
          style: TextStyle(fontSize: 30),
        ),Text("Check Internet Connection & Restart Me")
      ],
    ));
  }
}
