import 'package:flutter/material.dart';

class About_Screen extends StatefulWidget {

  @override
  State<About_Screen> createState() => _About_ScreenState();
}

class _About_ScreenState extends State<About_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Screen"),
      ),
      body: Center(
        child: Text("This is Home Screen"),
      ),
    );
  }
}