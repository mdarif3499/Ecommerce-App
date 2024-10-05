import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/progressbar.dart';
import 'package:ecommerce_app/controllers/auth_controllers.dart';
import 'package:ecommerce_app/views/home_screen/Home.dart';
import 'package:get/get.dart';
import '../../widget_common/applogo_widget.dart';
import '../../widget_common/bg_widget.dart';
import '../../widget_common/comon_textfield.dart';
import '../../widget_common/our_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var controller = Get.put(AuthController());
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  bool? isCheck = false;

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            "Join the  $appname".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,
             Column(
                children: [
                  CustomTextField(
                      hint: nameHint, title: name, controller: nameController,isPass: false),
                  CustomTextField(
                      hint: emailHint, title: email, controller: emailController,isPass: false),
                  CustomTextField(
                      hint: passwordHint,
                      title: password,
                      controller: passwordController,isPass: true),
                  CustomTextField(
                      hint: retypePassword,
                      title: retypePassword,
                      controller: passwordRetypeController,isPass: true),
                  Align(
                    alignment: Alignment.centerRight,
                  ),
                  5.heightBox,
                  // OurButton(color: redColor,title: login,textColor: whiteColor,onPresss: (){}
                  // ).box.width(context.screenWidth -50).make(),

                  Row(
                    children: [
                      Checkbox(
                        activeColor: redColor,
                        checkColor: redColor,
                        value: isCheck,
                        onChanged: (newValue) {
                          setState(() {
                            isCheck = newValue;
                          });
                        },
                      ),
                      10.heightBox,
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "i agree to the ",
                              style: TextStyle(
                                  fontFamily: regular, color: fontGrey)),
                          TextSpan(
                              text: termAndCond,
                              style: TextStyle(
                                  fontFamily: regular, color: redColor)),
                          TextSpan(
                              text: " & ",
                              style: TextStyle(
                                  fontFamily: regular, color: redColor)),
                          TextSpan(
                              text: privacyPolicy,
                              style: TextStyle(
                                  fontFamily: regular, color: fontGrey)),
                        ])),
                      )
                    ],
                  ),
                  controller.isloading.value
                      ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  )
                      :
                  OurButton(
                          onPresss: () async {
                            // controller.isloading.value=true;
                            if (isCheck != false) {
                              try {
                                controller
                                    .signupMethod(
                                  context: context,
                                  email: emailController.text,
                                  password: passwordController.text,
                                )
                                    .then((value) {
                                      // controller.isloading.value=false;
                                  return controller.storeUserData(
                                      name: nameController.text,
                                      password: passwordController.text,
                                      email: emailController.text);
                                }).then((value) {

                                  VxToast.show(context, msg: loggedin);
                                    Get.offAll(()=>Home());
                                });
                              } catch (e) {
                                auth.signOut();
                                // controller.isloading.value=false;
                                VxToast.show(context, msg: e.toString());
                              }
                            }
                          },
                          color: isCheck == true ? redColor : lightGrey,
                          textColor: whiteColor,
                          title: signup)
                      .box
                      .width(context.screenWidth - 50)
                      .make(),
                  10.heightBox,
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                alreadyHaveAcount.text.color(fontGrey).make(),
                login.text.color(redColor).make().onTap(() {
                  Get.back();
                }),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
