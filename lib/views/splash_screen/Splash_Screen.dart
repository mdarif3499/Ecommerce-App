import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/sharedpreference_conest.dart';
import 'package:ecommerce_app/views/auth_screen/login_screen.dart';
import 'package:ecommerce_app/views/home_screen/home_screen.dart';
import 'package:ecommerce_app/widget_common/applogo_widget.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/sharedpreference_key.dart';
import '../home_screen/Home.dart';

class SplashScreen extends StatefulWidget {

const  SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  changeScreen() async{
    Future.delayed(const Duration(seconds: 3), () async {


      var  result =await MySharedPreference.getBool(LOGIN_CHECK);

      if(result!=null&&result==true){
        Get.offAll(() => Home());
      }else{
        Get.offAll(() => LoginScreen());

      }

      // auth.authStateChanges().listen((User? user) {
      //   if (user == null && mounted) {
      //     Get.offAll(() => LoginScreeen());
      //   } else {
      //     Get.offAll(() => LoginScreeen());
      //
      //     // Get.to(() => Home());
      //   }
      // }
      //
      // );
    });
  }

  @override
  void initState()
  {
     changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  icSplashBg,
                  width: 300,
                )),
            20.heightBox,
            applogoWidget(),
            10.heightBox,
            appname.text.fontFamily(bold).size(22).white.make(),
            5.heightBox,
            appversion.text.white.make(),
            const Spacer(),
            credits.text.white.fontFamily(semibold).make(),
            20.heightBox,
          ],
        ),
      ),
    );
  }
  void getValue()async{
    var pref = await SharedPreferences.getInstance();
  var isCheck=  pref.getBool(LOGIN_CHECK);
  if(isCheck!=null&&isCheck==true){
    Get.offAll(() => Home());
  }else{
    Get.offAll(() => LoginScreen());

  }

  }
}
