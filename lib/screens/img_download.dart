import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:image_downloader/image_downloader.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:dio/dio.dart';

class img_download extends StatefulWidget {
  const img_download({super.key});

  @override
  State<img_download> createState() => _img_downloadState();
}

class _img_downloadState extends State<img_download> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Download"),
      ),
      body: Column(
        children: [
          Image.network("https://i.pcmag.com/imagery/articles/078vnaOpSHd4QlOGOHzNftv-1..v1607443163.jpg"),
          Center(
            child: ElevatedButton(
              onPressed: ()async{
                String url="https://i.pcmag.com/imagery/articles/078vnaOpSHd4QlOGOHzNftv-1..v1607443163.jpg";
                print(url);

                await GallerySaver.saveImage(url,toDcim: true).then((value){
                  print("Second : "+url);
                  AlertDialog(
                    title: Text("YOur Image downloaded successfully!!"),
                    
                  );
                },);
              },
              child:Text("Download") ),
          )
        ],
      ),
    );
  }
}