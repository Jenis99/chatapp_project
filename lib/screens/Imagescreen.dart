import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Imagescren extends StatefulWidget {
  var imageid="";
  Imagescren({required this.imageid});

  @override
  State<Imagescren> createState() => _ImagescrenState();
}

class _ImagescrenState extends State<Imagescren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image"),
      ),
      body: Container(
        child: Column(
          children: [
            Image.network(widget.imageid,width: 200.0,),
          ],
        ),
      ),
    );
  }
}