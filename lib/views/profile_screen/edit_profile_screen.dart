import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../consts/consts.dart';
import '../../controllers/profile_controlller.dart';
import '../../widget_common/bg_widget.dart';
import '../../widget_common/comon_textfield.dart';
import '../../widget_common/our_button.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     var controller = Get.find<ProfileController>();

    return bgWidget(
        child: Scaffold(
      appBar: AppBar(),
      body:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:Obx(()=>
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  data['imageUrl'] == '' && controller.profileImagePath.isEmpty
                      ? Image.asset(
                    imgProfile2,
                    width: 80,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make()
                      : data['imageUrl'] != '' &&
                      controller.profileImagePath.isEmpty
                      ? Image.network(
                    data['imageUrl'],
                    width: 100,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make()
                      : Image.file(
                    File(controller.profileImagePath.value),
                    width: 100,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make(),
                  10.heightBox,
                  OurButton(
                      color: redColor,
                      onPresss: () {
                        controller.changeImage(context);
                      },
                      textColor: whiteColor,
                      title: "Change"),
                  Divider(),
                  20.heightBox,
                  CustomTextField(
                      controller: controller.nameController,
                      hint: nameHint,
                      title: "name",
                      isPass: false),
                  10.heightBox,
                  CustomTextField(
                      controller: controller.oldPassController,
                      hint: passwordHint,
                      title: oldPass,
                      isPass: true),
                  10.heightBox,
                  CustomTextField(
                      controller: controller.newPassController,
                      hint: passwordHint,
                      title: newPass,
                      isPass: true),
                  20.heightBox,
                  controller.isLoading.value
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  )
                      : OurButton(
                      color: redColor,
                      onPresss: () async {
                        // VxToast.show(context, msg: controller.profileImageLink.toString());

                        controller.isLoading(true);
//if image is not selected
                        if (controller.profileImagePath.value.isNotEmpty) {
                          await controller.uploadeImage(context: context);
                        } else {
                          controller.profileImageLink = data['imageUrl'];
                        }
                        //if old password matches data base
                        if (controller.oldPassController.text ==
                            data['password']) {
                          await controller.changeAuthPassword(
                              email: data['email'],
                              password: controller.oldPassController.text,
                              newPassword: controller.newPassController);

                          await controller.updateProfile(
                              imageUrl: controller.profileImageLink,
                              name: controller.nameController.text,
                              password: controller.newPassController.text);
                          VxToast.show(context, msg: "Updated");
                        } else {
                          VxToast.show(context, msg: "Wrong old password");
                          controller.isLoading(false);
                        }
                      },
                      textColor: whiteColor,
                      title: "save")
                      .box
                      .size(context.screenWidth - 60, 42)
                      .make()
                      .box
                      .color(redColor)
                      .make(),
                ],
              )
                  .box
                  .white
                  .margin(EdgeInsets.only(top: 50, left: 12, right: 12))
                  .shadowSm
                  .padding(EdgeInsets.all(16))
                  .rounded
                  .make(),

          )
        ),
      ),
    );
  }
}
