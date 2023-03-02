import 'package:chatapp_project/screens/About_Screen.dart';
import 'package:chatapp_project/screens/LoginScreen.dart';
import 'package:chatapp_project/screens/cloudnotification.dart';
import 'package:chatapp_project/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/HomeScreen.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/launch_background',
    [
      NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white),

    ],
    // Channel groups are only visual and are not required
   
  );


   FirebaseMessaging.onMessage.listen((RemoteMessage message){
     RemoteNotification? notification = message.notification;
      if (notification != null ) {
        var title = notification.title.toString();
        var body = notification.body.toString();

        //alert Dialoag
        //Awesome
        print("Title : "+title);
        print("Body : "+body);
          AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: title,
                body: body,
            )
          );
      }
   });



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
 
   
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      home: splacescreen(),
    );
  }
}


