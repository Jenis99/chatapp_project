import 'package:chatapp_project/screens/LoginScreen.dart';
import 'package:chatapp_project/screens/chatscreen.dart';
import 'package:chatapp_project/screens/img_download.dart';
import 'package:chatapp_project/screens/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'About_Screen.dart';
class HomeScreen extends StatefulWidget {
  
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  var name="";
    var email="";
    var googleid="";
    var photo="";
    bool isloading=false;

  getinfo()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name =prefs.getString("name").toString();
      email =prefs.getString("email").toString();
      photo =prefs.getString("photo").toString();
      googleid =prefs.getString("id").toString();
    });
  }
  listenActionStream() async{
 await AwesomeNotifications().actionStream.listen((action) {
  var payload = action.payload;
  print(action.buttonKeyPressed.toString());
    if(action.buttonKeyPressed == "home"){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=>HomeScreen())
      );
    }else if(action.buttonKeyPressed == "about"){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=>About_Screen())
      );
    }    
    else{
             print(action.payload); //notification was pressed
          }   
  });
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenActionStream();
    getinfo();
  
  }
   final GoogleSignIn? googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      appBar: AppBar(
        title: Text("Homescreen"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Welcome,"+ name+"!"),
              accountEmail: Text(email), 
              currentAccountPicture: CircleAvatar(
                child:Image.network(photo),
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Id  : "+googleid,),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>LoginScreen())
                );
              },
            ),
            Center(
              child: ElevatedButton(onPressed: ()async{
                SharedPreferences prefs =await SharedPreferences.getInstance();
                prefs.clear();
                googleSignIn!.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>LoginScreen())
                );
              }, child: Text("Singout")),
            ),
            SizedBox(height: 20.0,),
            Center(
              child: ElevatedButton(onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder:(context)=>notification())
                );
              }, child: Text("notification")),
            ),
            Center(
              child: ElevatedButton(onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder:(context)=>img_download())
                );
              }, child: Text("Download")),
            ),
          ],
        ),
      ),
      body: (email!="")?StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Userdata")
        .where("email",isNotEqualTo: email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData)
          {
            if(snapshot.data!.size<=0)
            {
              return Center(
                child: Text("No Data"),
              );
            }
            else 
            {
              return ListView(
                children: snapshot.data!.docs.map((document){
                  
                   return ListTile(
                    title: Text(document["name"].toString()),
                    subtitle: Text(document["email"].toString()),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.network(document["photo"].toString())),
                    
                    onTap: (){
                      var id = document.id.toString();
                      var email=document["email"].toString();
                      var photo=document["photo"].toString();
                      var name=document["name"].toString();
                     // print(id.toString());
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>chatscreen(
                          cid: id,email: email,photo: photo,name: name,))
                      );
                    },
                  );
                }).toList(),
              );
            }
          }
          else
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ):Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}