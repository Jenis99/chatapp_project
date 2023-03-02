import 'package:chatapp_project/screens/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth  = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: ()async{
            final GoogleSignIn? googleSignIn = GoogleSignIn();
            final GoogleSignInAccount? googleSignInAccount = await googleSignIn!.signIn();
            if (googleSignInAccount != null)
            {
              final GoogleSignInAuthentication googleSignInAuthentication =
                  await googleSignInAccount.authentication;
              final AuthCredential authCredential = GoogleAuthProvider.credential(
                  idToken: googleSignInAuthentication.idToken,
                  accessToken: googleSignInAuthentication.accessToken);
              
              // Getting users credential
              UserCredential result = await auth.signInWithCredential(authCredential); 
              User? user = result.user;
               var name = user!.displayName.toString();
              var email = user!.email.toString();
              var photo = user!.photoURL.toString();
              var googleid = user!.uid.toString();


              //check

              await FirebaseFirestore.instance.collection("Userdata")
              .where("email",isEqualTo: email).get().then((documents) async{

                if(documents.docs.isEmpty)
                {
                  
                    // for data insert firebase
                  await FirebaseFirestore.instance.collection("Userdata").add({
                    "name":name,
                    "email":email,
                    "photo":photo,
                    "id":googleid,
                  }).then((document) async{

                    // for data insert firebase 
                    // for insert in local storage
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString("name",name);
                    prefs.setString("email",email);
                    prefs.setString("photo",photo);
                    prefs.setString("id",googleid);
                    prefs.setString("senderid", document.id.toString());
                    // for insert in local storage
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>HomeScreen())
                    );

                  });
                }
                else
                {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString("name",name);
                    prefs.setString("email",email);
                    prefs.setString("photo",photo);
                    prefs.setString("id",googleid);
                    prefs.setString("senderid", documents.docs.first.id.toString());
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context)=>HomeScreen())
                    );
                }

              });
          };
          },
          child: Text("Login")
          ),
      ),
    );
  }
}