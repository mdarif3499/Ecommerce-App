import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/views/cart_screen/cart_screen.dart';
import 'package:ecommerce_app/views/categoary_screen/categoary_screen.dart';
import 'package:ecommerce_app/views/home_screen/home_screen.dart';
import 'package:ecommerce_app/views/profile_screen/profile_screen.dart';
import 'package:ecommerce_app/widget_common/exit_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Home extends StatelessWidget {
   Home({Key? key}) : super(key: key);
  var controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    var navBarItem = [
      BottomNavigationBarItem(
          icon: Image.asset(
            icHome,
            width: 26,
          ),
          label: home),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCategories,
            width: 26,
          ),
          label: categories),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCart,
            width: 26,
          ),
          label: cart),
      BottomNavigationBarItem(
          icon: Image.asset(
            icProfile,
            width: 26,
          ),
          label: account),
    ];
    var navBody = [
       HomeScreen(),
      const CategoaryScreen(),
      const CartScreen(),
      ProfileScreen(),
    ];
    return WillPopScope(

      onWillPop: ()async{
        showDialog(
            barrierDismissible: false,
            context: context, builder: (context)=>exitDialog(context));
        return false;
      },
      child: Scaffold(
          body: Column(
      
          children: [
            Obx(() =>Expanded(
      
              child: navBody.elementAt(controller.currenentNavIndex.value),)
      ),
      ],
      ),
      bottomNavigationBar: Obx(()=>
          BottomNavigationBar(
            currentIndex:controller. currenentNavIndex.value,
            selectedItemColor: redColor,
            selectedLabelStyle: TextStyle(fontFamily: semibold),
            type: BottomNavigationBarType.fixed,
            backgroundColor: whiteColor,
            items: navBarItem,
            onTap: (value) {
      
                controller.currenentNavIndex.value = value;
      
      
            },
          )
        ,
      )
      
      
      
        ),
    );
}}
