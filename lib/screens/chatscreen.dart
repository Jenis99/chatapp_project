import 'dart:io';
import 'package:chatapp_project/screens/Imagescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
// import 'package:image_downloader/image_downloader.dart';
class chatscreen extends StatefulWidget {
  
var cid="";
 var name="";
  var email="";
  var photo="";
chatscreen({required this.cid,required this.name,required this.email,required this.photo});
  @override
  State<chatscreen> createState() => _chatscreenState();
  
  
}

class _chatscreenState extends State<chatscreen> {
  
   File? selectedfile;
  TextEditingController _msg=TextEditingController();
  ImagePicker _picker = ImagePicker();
  ScrollController _scrollController =  ScrollController();
  // FocusNode focusnode = FocusNode();
  var sender="";
   
  bool showEmoji = false;

  FocusNode focusNode = FocusNode();

  loaddata() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sender=prefs.getString("senderid").toString(); 
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          setState(() {
            showEmoji = false;
          });
        }
      },
    );
    loaddata();
  }
 
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        if (showEmoji) {
          setState(() {
            showEmoji = false;
          });
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
         appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                leadingWidth: 70,
                titleSpacing: 0,
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(  
                        Icons.arrow_back,
                        size: 24,
                      ),
                      (widget.photo!="")?ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child:Image.network(widget.photo,width: 45.0,),
                         ):SizedBox(),
                    ]
                      ),
                  ),
               
                title: InkWell(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.all(6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name,
                          style: TextStyle(
                            fontSize: 18.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.email,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                 foregroundColor: Colors.black,
        backgroundColor: Color(0xffffffff),
              ),
              
         ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: (sender!="")?StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("Userdata").doc(sender)
                    .collection("Chats").doc(widget.cid).collection("messages")
                    .orderBy("timestamp",descending: true).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
                    {
                      if(snapshot.hasData)
                      {
                         if(snapshot.data!.size<=0)
                          {
                            return Center(
                              child: Text("No Chats"),
                            );
                          }
                          else 
                          {
                            return ListView(
                               controller: _scrollController,
                              reverse: true,
                              children: snapshot.data!.docs.map((document){
                                if(sender == document["senderid"].toString())
                                {
                                  return Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: (){
                                        if(document["type"].toString()=="image"){
                                           var image=document["msg"];
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context)=>Imagescren(imageid: image,))
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Color(0xffFFFFFF),
                                        ),
                                         margin: EdgeInsets.all(5.0),
                                        padding: EdgeInsets.all(10.0),
                                        child: (document["type"].toString()=="image")?
                                        Image.network(document["msg"],width: 100.0,):Text(document["msg"].toString(),style: TextStyle(
                                          color: Color(0xff368CFF),
                                          fontSize:18.0
                                        ),),
                                      ),
                                    ),
                                  );
                                }
                                else
                                {
                                   return Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: (){
                                        if(document["type"].toString()=="image"){
                                           var image=document["msg"];
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context)=>Imagescren(imageid: image,))
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Color(0xff1853A1),
                                        ),
                                         margin: EdgeInsets.all(10.0),
                                        padding: EdgeInsets.all(10.0),
                                        child: (document["type"].toString()=="image")?
                                        Image.network(document["msg"],width: 100.0,):Text(document["msg"].toString(),style: TextStyle(
                                          color: Colors.white,
                                          fontSize:18.0
                                        ),),
                                      ),
                                    ),
                                  );
                                }
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
                  ):SizedBox(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 60,
                            child: Card(
                              margin: EdgeInsets.only(
                                  left: 2, right: 2, bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextFormField(
                                // focusNode: focusnode,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 1,
                                controller: _msg,
                                onTap: () {
                                  //key
                                 if(showEmoji){
                                   setState(() {
                                 showEmoji = !showEmoji;
                              });
                                 }
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                      Icons.emoji_emotions_outlined,
                                    ),
                                    onPressed: () {
                                     // 
                                    //     focusnode.unfocus();
                                    // focusnode.canRequestFocus=false;
                                       setState(() {
                                 showEmoji = !showEmoji;
                              });
                              FocusScope.of(context).unfocus();
                                    },
                                  ),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.attach_file),
                                        onPressed: () async{
                                           XFile? photo = await _picker.pickImage(
                                          source: ImageSource.gallery);
                              selectedfile = File(photo!.path);

                                          var uuid = Uuid();
                                          var filename =  uuid.v4();

                                          await FirebaseStorage.instance.ref(filename)
                                          .putFile(selectedfile!).whenComplete((){}).then((filedata) async{
                                            await filedata.ref.getDownloadURL().then((fileurl) async{
                                               SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    var senderid=prefs.getString("senderid").toString(); // Sa
                                                    var receiverid = widget.cid.toString(); //pv
                                                    var msg =_msg.text.toString();
                                                    _msg.text="";
                                                    await FirebaseFirestore.instance.collection("Userdata")
                                                    .doc(senderid).collection("Chats").doc(receiverid)
                                                    .collection("messages").add({
                                                        "senderid":senderid,
                                                        "receiverid":receiverid,
                                                        "type":"image",
                                                        "msg":fileurl,
                                                        "timestamp":DateTime.now().millisecondsSinceEpoch
                                                    }).then((value) async{
                                                      _scrollController.animateTo(
                                                          _scrollController.position.minScrollExtent,
                                                          duration:Duration(milliseconds: 2),
                                                          curve:Curves.fastOutSlowIn,
                                                        );
                                                      await FirebaseFirestore.instance.collection("Userdata")
                                                      .doc(receiverid).collection("Chats").doc(senderid)
                                                      .collection("messages").add({
                                                        "senderid":senderid,
                                                        "receiverid":receiverid,
                                                        "type":"image",
                                                        "msg":fileurl,
                                                        "timestamp":DateTime.now().millisecondsSinceEpoch
                                                      }).then((value){
                                                        //sqflite
                                                    });
                        
                                                  },
                                                );
                                            });
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.camera_alt),
                                        onPressed: ()async {
                                           XFile? photo = await _picker.pickImage(
                                          source: ImageSource.camera);

                                         selectedfile = File(photo!.path);

                                          var uuid = Uuid();
                                          var filename =  uuid.v4();

                                          await FirebaseStorage.instance.ref(filename)
                                          .putFile(selectedfile!).whenComplete((){}).then((filedata) async{
                                            await filedata.ref.getDownloadURL().then((fileurl) async{
                                               SharedPreferences prefs = await SharedPreferences.getInstance();
                                                    var senderid=prefs.getString("senderid").toString(); // Sa
                                                    var receiverid = widget.cid.toString(); //pv
                                                    var msg =_msg.text.toString();
                                                    _msg.text="";
                                                    await FirebaseFirestore.instance.collection("Userdata")
                                                    .doc(senderid).collection("Chats").doc(receiverid)
                                                    .collection("messages").add({
                                                        "senderid":senderid,
                                                        "receiverid":receiverid,
                                                        "type":"image",
                                                        "msg":fileurl,
                                                        "timestamp":DateTime.now().millisecondsSinceEpoch
                                                    }).then((value) async{
                                                      _scrollController.animateTo(
                                                          _scrollController.position.minScrollExtent,
                                                          duration:Duration(milliseconds: 2),
                                                          curve:Curves.fastOutSlowIn,
                                                        );
                                                      await FirebaseFirestore.instance.collection("Userdata")
                                                      .doc(receiverid).collection("Chats").doc(senderid)
                                                      .collection("messages").add({
                                                        "senderid":senderid,
                                                        "receiverid":receiverid,
                                                        "type":"image",
                                                        "msg":fileurl,
                                                        "timestamp":DateTime.now().millisecondsSinceEpoch
                                                      }).then((value){
                                                        
                                                    });
                        
                                                  },
                                                );
                                            });
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8,
                              right: 2,
                              left: 2,
                            ),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor:Color(0xff1853A1),
                              child: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                onPressed: ()  async{
                                   SharedPreferences prefs = await SharedPreferences.getInstance();
                                   var senderid=prefs.getString("senderid").toString(); // Sa
                                   var receiverid = widget.cid.toString(); //pv
                                   var msg =_msg.text.toString();
                                   _msg.text="";
                                   await FirebaseFirestore.instance.collection("Userdata")
                                   .doc(senderid).collection("Chats").doc(receiverid)
                                   .collection("messages").add({
                                      "senderid":senderid,
                                      "receiverid":receiverid,
                                      "type":"text",
                                      "msg":msg,
                                      "timestamp":DateTime.now().millisecondsSinceEpoch
                                   }).then((value) async{
                                    _scrollController.animateTo(
                                        _scrollController.position.minScrollExtent,
                                        duration:Duration(milliseconds: 2),
                                        curve:Curves.fastOutSlowIn,
                                      );
                                    await FirebaseFirestore.instance.collection("Userdata")
                                    .doc(receiverid).collection("Chats").doc(senderid)
                                    .collection("messages").add({
                                       "senderid":senderid,
                                      "receiverid":receiverid,
                                      "type":"text",
                                      "msg":msg,
                                      "timestamp":DateTime.now().millisecondsSinceEpoch
                                    }).then((value){
                                      
                                   });
      
                                },
                              );
                                }
                            )
                          ),
                          ),
                          ],
                      ),
                   
                    ],
                  ),
                ),
              ),
                showEmoji ? showEmojiPicker() : Container(),
                    
            ],
          ),
        ),
      ),
    );
  }
   Widget showEmojiPicker() {
    return SizedBox(
      height:277.0,
      child: EmojiPicker(
        textEditingController: _msg,
        config: Config(
          columns: 7,
           emojiSizeMax: 32,
        ),
      ),
    );
  }
}
 