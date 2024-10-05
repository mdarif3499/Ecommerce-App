import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/progressbar.dart';
import 'package:ecommerce_app/consts/sharedpreference_conest.dart';
import 'package:ecommerce_app/views/chat_screen/messages_screeen.dart';
import 'package:ecommerce_app/views/orders_screen/orders_screen.dart';
import 'package:ecommerce_app/views/wishlist_screen/wishlist_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts/consts.dart';
import '../../consts/lists.dart';
import '../../consts/sharedpreference_key.dart';
import '../../controllers/profile_controlller.dart';
import '../../services/firestore_services.dart';
import '../../widget_common/bg_widget.dart';
import '../auth_screen/login_screen.dart';
import 'compunent/details_button.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    User? currentUser1 = auth.currentUser;
    return bgWidget(
        child: Scaffold(
            body: Center(
              child: StreamBuilder(
                  stream: FirestorServices.getUser(currentUser1!.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData && mounted) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        ),
                      );
                    } else {
                      var data = snapshot.data!.docs[0];
                      return SafeArea(
                        child: Column(
                          children: [
                            //edit profile button
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.edit,
                                  color: whiteColor,
                                ),
                              ).onTap(() {
                                controller.nameController.text = data['name'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfileScreen(data: data),
                                  ),
                                );

                                // Get.to(() =>
                                //     EditProfileScreen(
                                //       data: data,
                                //     ));
                              }),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  data['imageUrl'] != ''
                                      ? Image
                                      .network(
                                    data['imageUrl'],
                                    width: 80,
                                    fit: BoxFit.cover,
                                  )
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make()
                                      : Image
                                      .asset(
                                    imgProfile2,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  )
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make(),
                                  10.widthBox,
                                  Expanded(
                                      child: Column(

                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [

                                          "${data['name']}"
                                              .text
                                              .fontFamily(semibold)
                                              .white
                                              .make(),
                                          "${data['email']}".text.white.make()
                                        ],
                                      )),


                                  //LogOut button

                                  OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: whiteColor,
                                          )),
                                      onPressed: () async {
                                       await controller.signOutMethod(context);
                                         MySharedPreference.setBool(LOGIN_CHECK, false);
                                        Get.offAll(() => LoginScreen());
                                      },
                                      child: logout.text.white
                                          .fontFamily(semibold)
                                          .make()),
                                  5.heightBox,
                                ],
                              ),
                            ),
                            20.heightBox,

                            FutureBuilder(future: FirestorServices.getCount(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: loadingIndicator(),
                                    );
                                  } else {
                                  var countData = snapshot.data;
                                  return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                  DetailsCart(
                                  title: "in your cart",
                                  count: countData[0].toString(),
                                  width: context.screenWidth / 3.4),
                                  DetailsCart(
                                  title: "in your wishlist",
                                  count: countData[1].toString(),
                                  width: context.screenWidth / 3.4),
                                  DetailsCart(
                                  title: "Your orders",
                                  count: countData[2].toString(),
                                  width: context.screenWidth / 3.4),
                                  ],
                                  );

                                }


                                }),


                            ListView
                                .separated(
                                shrinkWrap: true,
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: lightGrey,
                                  );
                                },
                                itemCount: prifileButtonList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                      onTap: () {
                                        switch (index) {
                                          case 0 :
                                            Get.to(() => OrderScreen());
                                            break;
                                          case 1 :
                                            Get.to(() => WishlistScreen());
                                            break;
                                          case 2 :
                                            Get.to(() => MessagesScreen());
                                            break;
                                        }
                                      },
                                      leading: Image.asset(
                                        prifileIconList[index],
                                        width: 22,
                                      ),
                                      title: prifileButtonList[index]
                                          .text
                                          .color(darkFontGrey)
                                          .fontFamily(semibold)
                                          .make());
                                })
                                .box
                                .rounded
                                .white
                                .margin(EdgeInsets.all(8))
                                .padding(EdgeInsets.symmetric(horizontal: 16))
                                .shadowSm
                                .make()
                                .box
                                .color(redColor)
                                .make()
                          ],
                        ),
                      );
                    }
                  }
              ),
            )
        )
    );
  }

  void getValue() async {
    var pref = await SharedPreferences.getInstance();
    pref.setBool(LOGIN_CHECK, false);
    Get.offAll(() => LoginScreen());
  }

}
