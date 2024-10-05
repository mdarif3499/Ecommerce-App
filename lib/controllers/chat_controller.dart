import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  @override
  void onInit() {

    getChatId();
    super.onInit();
  }
  var chats = firestore.collection(chatCollection);
  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get
      .find<HomeController>()
      .userName;
  var currentId = currentUser?.uid;
  var msgController = TextEditingController();
  dynamic chatDocId;
  var isLoading=false.obs;

  getChatId() async {
    isLoading.value=true;
    await chats
        .where('users', isEqualTo: {friendId : "", currentId : ""})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        chatDocId = snapshot.docs.single.id;
        isLoading.value=false;
      } else {
        chats.add({
          'created_on': "",
          'last_msg': '',
          'users': {friendId: "", currentId: ""},
          'toId': '',
          'fromId': '',
          'friend_Name': friendName,
          'sender_Name': senderName
        }).then((value) {
          chatDocId = value.id;
          isLoading.value=false;
        });
      }
    });
  }


  sendMsg(String msg) async{
    if (msg.trim().isNotEmpty){
      await chats.doc(chatDocId).update({
        'created_on':FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': friendId,
        'fromId': currentId,


      });
      chats.doc(chatDocId).collection(messageCollection).doc().set({
        'created_on':FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,

      });
    }
  }

}
