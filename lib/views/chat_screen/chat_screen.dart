import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/progressbar.dart';
import 'package:ecommerce_app/controllers/chat_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/chat_screen/component/sender_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChatController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "${controller.friendName}".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() =>
            controller.isLoading.value ? Center(
              child: loadingIndicator(),
            ) :
            Expanded(
                child: StreamBuilder(
                  stream: FirestorServices.getChatMessage(
                      controller.chatDocId.toString()),
                  builder:
                      (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: loadingIndicator(),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: "Sand a message...".text.color(darkFontGrey)
                            .make(),
                      );
                    } else {
                      return ListView(
                          children: snapshot.data!.docs.mapIndexed((
                              currentValue, index) {
                            var data = snapshot.data!.docs[index];
                            return Align(
                                alignment: data['uid'] == currentUser!.uid
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,

                                child: SenderBubble(data));
                          }).toList()
                      );
                    }
                  },
                )),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                      controller: controller.msgController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: textfieldGrey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textfieldGrey)),
                          hintText: "Type a message..."),
                    )),
                IconButton(
                    onPressed: () async {
                      await controller.sendMsg(controller.msgController.text);
                      controller.msgController.clear();
                    },
                    icon: Icon(
                      Icons.send,
                      color: redColor,
                    ))
              ],
            )
                .box
                .height(80)
                .padding(EdgeInsets.all(12))
                .margin(EdgeInsets.only(bottom: 8))
                .make()
          ],
        ),
      ),
    );
  }
}
