import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
class notification extends StatefulWidget {
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async{

                 bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
                 if(isAllowed)
                 {
                      AwesomeNotifications().createNotification(
                                  content: NotificationContent(
                                      id: 10,
                                      channelKey: 'basic_channel',
                                      title: 'New Offer!',
                                      body: 'Open our app to get the latest offers!',
                                  )
                                );
                 }
                 else
                 {
                   displayNotificationRationale(context);
                 }
               
            }, child:Text("Click")),
          ),
          ElevatedButton(
            onPressed: ()async{
              bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
              if(isAllowed){
                 await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'basic_channel',
            title: 'Huston! The eagle has landed!',
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
          ),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              isDangerousOption: true)
        ]);
              }
        else{
          displayNotificationRationale(context);
        }
          }, child: Text("Network Image Notification")),



          ElevatedButton(
            onPressed: ()async{
              bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
              if(isAllowed){
                 await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 11, // -1 is replaced by a random number
            channelKey: 'basic_channel',
            title: 'Huston! The eagle has landed!',
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'asset://img/download.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
             
          ),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              isDangerousOption: true),
              
        ],
        schedule: NotificationCalendar.fromDate(
            date: DateTime.now().add(const Duration(seconds: 10)))
                 );
              }
        else{
          displayNotificationRationale(context);
        }
          }, child: Text("Local Image Notification")),



          ElevatedButton(
            onPressed: ()async{
              bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
              if(isAllowed){
                 await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 11, // -1 is replaced by a random number
            channelKey: 'basic_channel',
            title: 'Huston! The eagle has landed!',
            body:
                "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'asset://img/download.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'home',
           label: 'Home'
           ),
          NotificationActionButton(
              key: 'about',
              label: 'About',
          ),    
        ],
                 );
              }
        else{
          displayNotificationRationale(context);
        }
          }, child: Text("Page Redirect"))   ,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: ()async{
                 bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
              if(isAllowed){
                 await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 11, // -1 is replaced by a random number
            channelKey: 'basic_channel',
            title: 'This is Notification ',
            body:
                "This is only for demo purpose",
            bigPicture: 'asset://img/download.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,));
              }
              },
               child: Text("Get Notification")),
               
              ElevatedButton(onPressed: ()async{
                AwesomeNotifications().dismiss(11);
              },
               child: Text("Dimiss Notification")),
            ],
          )    
       ],
      ),

    );
  }
   static Future<bool> displayNotificationRationale(context) async {
    bool userAuthorized = false;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'img/chat_logo.jpg',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

}