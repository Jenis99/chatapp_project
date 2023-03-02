import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class cloudnotification extends StatefulWidget {

  @override
  State<cloudnotification> createState() => _cloudnotificationState();
}

class _cloudnotificationState extends State<cloudnotification> {

  var token;

  getdata() async
  {
    SharedPreferences prefs =await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CLoud Notification"),
      ),
      body: (token!=null)?Center(
        child: Text(token),
      ):SizedBox(),
    );
  }
}