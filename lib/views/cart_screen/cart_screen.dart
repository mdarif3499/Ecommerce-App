import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/progressbar.dart';
import 'package:ecommerce_app/controllers/cart_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/cart_screen/shipping_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../widget_common/our_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;


    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 60,
        width: context.screenWidth - 60,
        child: OurButton(
            color: redColor,
            onPresss: () {
              Get.to(()=>ShippingDetails());
            },
            textColor: whiteColor,
            title: "Proceed to Shipping"),
      ),
        backgroundColor: whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: "Shoping Cart"
              .text
              .color(darkFontGrey)
              .fontFamily(semibold)
              .make(),
        ),
        body: StreamBuilder(
          stream: FirestorServices.getCart(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                  child: "Cart is empty".text.color(darkFontGrey).make());
            } else {
              var data = snapshot.data!.docs;
              controller.calculate(data);
              controller.productSnapshot=data;

              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(

                              leading: Image.network("${data[index]['img']}",width: 80,fit: BoxFit.cover,)
                                  .box
                                  .make(),
                              title:
                                  "${data[index]['title']} (x${data[index]['qty']})"
                                      .text
                                      .fontFamily(semibold)
                                      .size(16)
                                      .make(),
                              subtitle: "${data[index]['tprice']}"
                                  .numCurrency
                                  .text
                                  .color(redColor)
                                  .fontFamily(semibold)
                                  .make(),
                              trailing: Icon(
                                Icons.delete,
                                color: redColor,
                              ).onTap(() {
                                FirestorServices.deleteDocument(data[index].id);
                              }),
                            );
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Total price"
                            .text
                            .color(darkFontGrey)
                            .fontFamily(semibold)
                            .make(),
                        Obx(
                          () => "${controller.totalP.value}"
                              .numCurrency
                              .text
                              .color(redColor)
                              .fontFamily(semibold)
                              .make(),
                        ),
                      ],
                    )
                        .box
                        .padding(EdgeInsets.all(12))
                        .width(context.screenWidth - 60)
                        .color(lightGolden)
                        .make(),
                    // SizedBox(
                    //   width: context.screenWidth - 60,
                    //   child: OurButton(
                    //       color: redColor,
                    //       onPresss: () {},
                    //       textColor: whiteColor,
                    //       title: "Proceed to Shipping"),
                    // )
                  ],
                ),
              );
            }
          },
        ));
  }
}
