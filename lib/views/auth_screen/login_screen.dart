import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/consts/sharedpreference_conest.dart';
import 'package:ecommerce_app/consts/sharedpreference_key.dart';
import 'package:ecommerce_app/controllers/auth_controllers.dart';
import 'package:ecommerce_app/views/auth_screen/signup_screen.dart';
import 'package:ecommerce_app/widget_common/applogo_widget.dart';
import 'package:ecommerce_app/widget_common/bg_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget_common/comon_textfield.dart';
import '../../widget_common/our_button.dart';
import '../home_screen/Home.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var controler = Get.put(AuthController());

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
            "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
            15.heightBox,
            Column(
              children: [
                CustomTextField(
                    hint: emailHint,
                    title: email,
                    isPass: false,
                    controller: controler.emailControler),
                CustomTextField(
                    hint: passwordHint,
                    title: password,
                    isPass: true,
                    controller: controler.passControler),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: forgetPassword.text.make(),
                  ),
                ),
                5.heightBox,
                controler.isloading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor),
                      )
                    : OurButton(
                            onPresss: () async {
                              controler
                                  .loginMethod(context: context)
                                  .then((value) {
                                if (value != null) {
                                  VxToast.show(context, msg: "logined");
                                  MySharedPreference.setBool(LOGIN_CHECK, true);

                                  Get.to(Home());
                                }
                              });
                            },
                            color: redColor,
                            textColor: whiteColor,
                            title: login)
                        .box
                        .width(context.screenWidth - 50)
                        .make(),
                5.heightBox,
                createNewAcccount.text.color(fontGrey).make(),
                5.heightBox,
                OurButton(
                    color: lightGolden,
                    title: signup,
                    textColor: redColor,
                    onPresss: () {
                      Get.to(() => SignupScreen());
                    }).box.width(context.screenWidth - 50).make(),
                10.heightBox,
                loginWith.text.color(fontGrey).make(),
                5.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      3,
                      (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: lightGrey,
                              radius: 25,
                              child: Image.asset(
                                socialIconList[index],
                                width: 30,
                              ),
                            ),
                          )),
                )
              ],
            )
                .box
                .white
                .rounded
                .padding(const EdgeInsets.all(16))
                .width(context.screenWidth - 70)
                .shadowSm
                .make(),
          ],
        ),
      ),
    ));
  }

  void getValue() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool(LOGIN_CHECK, true);
    Get.offAll(Home());
  }
}
