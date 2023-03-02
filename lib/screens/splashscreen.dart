import 'package:chatapp_project/screens/HomeScreen.dart';
import 'package:chatapp_project/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'About_Screen.dart';
import 'cloudnotification.dart';
class splacescreen extends StatefulWidget {
  const splacescreen({super.key});

  @override
  State<splacescreen> createState() => _splacescreenState();
}

class _splacescreenState extends State<splacescreen> {

  checkligin()async{
    await FirebaseMessaging.instance.getToken().then((token) async{
      print("Token : "+token.toString());
        SharedPreferences prefs =await SharedPreferences.getInstance();
        prefs.setString("token", token!.toString());
        Navigator.of(context).pop();
        Navigator.of(context).push(
        MaterialPageRoute(builder: ((context) => cloudnotification())));
    });
   
          
    // if(prefs.containsKey("name")){
    //     Navigator.of(context).pop();
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: ((context) => HomeScreen())
    //   )
    //   );
    // }
    // else{
    //     Navigator.of(context).pop();
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: ((context) => LoginScreen())));
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkligin();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      body: Center(
        child: Image.asset("img/chat_logo.jpg"),
      ),
    );
  }
}