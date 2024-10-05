import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/product_controllers.dart';
import 'package:ecommerce_app/views/chat_screen/chat_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/state_manager.dart';

class ItemDetails extends StatelessWidget {
  final String? title;

  final dynamic data;

  ItemDetails({Key? key, required this.title, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return WillPopScope(
      onWillPop: () async {
        controller.resetValue();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValue();
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: title!.text.white.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                )),
            Obx(
              () => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removeWishlist(data.id, context);
                      // controller.isFav.value=false;
                    } else {
                      controller.addToWishlist(data.id, context);
                      // controller.isFav.value=true;
                    }
                  },
                  icon: Icon(
                    Icons.favorite_outline,
                    color: controller.isFav.value ? redColor : darkFontGrey,
                  )),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VxSwiper.builder(
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          height: 350,
                          viewportFraction: 1.0,
                          itemCount: data['p_imgs'].length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              data["p_imgs"][index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          }),
                      10.heightBox,
                      //title and details section
                      title!.text
                          .size(16)
                          .fontFamily(semibold)
                          .color(darkFontGrey)
                          .make(),
                      10.heightBox,
                      VxRating(
                        value: double.parse(data['p_rating']),
                        onRatingUpdate: (value) {},
                        normalColor: textfieldGrey,
                        selectionColor: golden,
                        count: 5,
                        size: 25,
                        isSelectable: false,
                        maxRating: 5,
                      ),
                      10.heightBox,
                      "${data['p_price']}"
                          .numCurrency
                          .text
                          .color(redColor)
                          .fontFamily(bold)
                          .size(18)
                          .make(),
                      10.heightBox,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['p_seller']}"
                                    .text
                                    .fontFamily(semibold)
                                    .white
                                    .make(),
                                5.heightBox,
                                "In House Brands"
                                    .text
                                    .color(darkFontGrey)
                                    .fontFamily(semibold)
                                    .size(16)
                                    .make()
                              ],
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.message_rounded,
                              color: darkFontGrey,
                            ).onTap(() {
                              Get.to(() => ChatScreen(), arguments: [
                                data['p_seller'],
                                data['vendor_id']
                              ]);
                            }),
                          )
                        ],
                      )
                          .box
                          .height(60)
                          .padding(EdgeInsets.symmetric(horizontal: 16))
                          .color(textfieldGrey)
                          .make(),
                      20.heightBox,
                      //color section
                      Obx(
                        () => Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child:
                                      "Color".text.color(textfieldGrey).make(),
                                ),
                                Row(
                                  children: List.generate(
                                      data['p_colors'].length,
                                      (index) => Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              VxBox()
                                                  .size(40, 40)
                                                  .roundedFull
                                                  .color(Color(data['p_colors']
                                                          [index])
                                                      .withOpacity(1.0))
                                                  .margin(EdgeInsets.symmetric(
                                                      horizontal: 4))
                                                  .make()
                                                  .onTap(() {
                                                controller
                                                    .changeColoreIndex(index);
                                              }),
                                              Visibility(
                                                visible: index ==
                                                    controller.colorIndex.value,
                                                child: Icon(
                                                  Icons.done,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          )),
                                ),
                              ],
                            ).box.padding(EdgeInsets.all(8)).make(),

                            //quainty Row
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Quaintity"
                                      .text
                                      .color(textfieldGrey)
                                      .make(),
                                ),
                                Obx(
                                  () => Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            controller.decreaseQuantity();
                                            controller.calculateTotalPrice(
                                                int.parse(data['p_price']));
                                          },
                                          icon: Icon(Icons.remove)),
                                      controller.quantity.value.text
                                          .size(16)
                                          .color(darkFontGrey)
                                          .fontFamily(bold)
                                          .make(),
                                      IconButton(
                                          onPressed: () {
                                            controller.increaseQuantity(
                                                int.parse(data['p_quantity']));
                                            controller.calculateTotalPrice(
                                                int.parse(data['p_price']));
                                          },
                                          icon: Icon(Icons.add)),
                                      10.widthBox,
                                      "(${data['p_quantity']})"
                                          .text
                                          .color(textfieldGrey)
                                          .make(),
                                    ],
                                  ),
                                ),
                              ],
                            ).box.padding(EdgeInsets.all(8)).make(),
                            //Total Row

                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child:
                                      "Total".text.color(textfieldGrey).make(),
                                ),
                                "${controller.totalPrice.value}"
                                    .numCurrency
                                    .text
                                    .size(16)
                                    .color(redColor)
                                    .fontFamily(bold)
                                    .make()
                              ],
                            ).box.padding(EdgeInsets.all(8)).make()
                          ],
                        ).box.shadowSm.white.make(),
                      ),
                      //desciption section
                      10.heightBox,
                      "Desciption"
                          .text
                          .fontFamily(bold)
                          .color(darkFontGrey)
                          .make(),
                      10.heightBox,
                      "${data['p_desc']}".text.color(darkFontGrey).make(),
                      10.heightBox,
                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                            itemDetailsButtonList.length,
                            (index) => ListTile(
                                  title: "${itemDetailsButtonList[index]}"
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  trailing: Icon(Icons.arrow_forward),
                                )),
                      ),
                      20.heightBox,
                      //   Product may like section
                      productsyoumayLike.text
                          .color(darkFontGrey)
                          .size(16)
                          .fontFamily(bold)
                          .make(),
                      10.heightBox,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: List.generate(
                                6,
                                (index) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          imgP1,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        10.heightBox,
                                        "Laptop 4/500"
                                            .text
                                            .fontFamily(semibold)
                                            .color(darkFontGrey)
                                            .make(),
                                        10.heightBox,
                                        "\$600"
                                            .text
                                            .fontFamily(bold)
                                            .color(redColor)
                                            .size(16)
                                            .make()
                                      ],
                                    )
                                        .box
                                        .white
                                        .roundedSM
                                        .margin(
                                            EdgeInsets.symmetric(horizontal: 4))
                                        .padding(EdgeInsets.all(8))
                                        .make())),
                      ),
                    ],
                  ),
                ),
              ),
            )),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlinedButton(
                  onPressed: () async {
                    if (controller.quantity.value > 0) {
                      await controller.addToCard(
                          context: context,
                          color: data['p_colors'][controller.colorIndex.value],
                          img: data['p_imgs'][0],
                          vendorID: data['vendor_id'],
                          qty: controller.quantity.value,
                          sellerName: data['p_seller'],
                          title: data['p_name'],
                          tprice: controller.totalPrice.value);
                    } else {
                      VxToast.show(context,
                          msg: "Minummum 1 product is requried");
                    }
                  },
                  child: Text(
                    "Add Cart",
                    style: TextStyle(color: Colors.white),
                  )).box.color(redColor).make(),
            )
          ],
        ),
      ),
    );
  }
}
