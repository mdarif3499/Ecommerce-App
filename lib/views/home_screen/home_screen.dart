import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/consts/progressbar.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/categoary_screen/item_details.dart';
import 'package:ecommerce_app/views/home_screen/searce_Screen.dart';
import 'package:ecommerce_app/widget_common/home_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../controllers/product_controllers.dart';
import 'components/featured_button.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  var controller = Get.put(ProductController());
  var homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightGrey,
      padding: const EdgeInsets.all(12),
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              alignment: Alignment.center,
              color: lightGrey,
              child: TextFormField(
                controller: homeController.searceController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search).onTap(() {
                    if (homeController
                        .searceController.text.isNotEmptyAndNotNull) {
                      Get.to(() => SearceScreen(
                            title: homeController.searceController.text,
                          ));
                    }
                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchanything,
                  hintStyle: TextStyle(color: textfieldGrey),
                ),
              ).box.shadow.make(),
            ),
            10.heightBox,
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: sliderList.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            sliderList[index],
                            fit: BoxFit.fill,
                          )
                              .box
                              .rounded
                              .shadow
                              .clip(Clip.antiAlias)
                              .margin(EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        }).box.color(lightGrey).make(),
                    10.heightBox,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          2,

                          (index) => homeButtons(
                                height: context.screenHeight * 0.15,
                                width: context.screenWidth / 2.5,
                                icon: index == 0 ? icTodaysDeal : icFlashDeal,
                                title: index == 0 ? todayDeal : flashsale,
                              )),
                    ),

                    10.heightBox,
                    //2nd swiper
                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: secondSliderList.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            secondSliderList[index],
                            fit: BoxFit.fill,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        }),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          3,
                          (index) => homeButtons(
                                height: context.screenHeight * 0.15,
                                width: context.screenWidth / 3.5,
                                icon: index == 0
                                    ? icTopCategories
                                    : index == 1
                                        ? icBrands
                                        : icTopSeller,
                                title: index == 0
                                    ? topCatregories
                                    : index == 1
                                        ? brand
                                        : topSellers,
                              )),
                    ),
                    // featured cateagries
                    20.heightBox,

                    Align(
                        alignment: Alignment.centerLeft,
                        child: featuredCatregories.text
                            .color(darkFontGrey)
                            .size(18)
                            .fontFamily(semibold)
                            .make()),
                    20.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: List.generate(
                              3,
                              (index) => Column(
                                    children: [
                                      featuredButton(
                                          icon: featuredImg1[index],
                                          title: featuredTitle1[index]),
                                      10.heightBox,
                                      featuredButton(
                                          icon: featuredImg2[index],
                                          title: featuredTitle2[index]),
                                    ],
                                  ))),
                    ),
                    //featured product
                    10.heightBox,
                    Container(
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: redColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProduct.text.white
                              .fontFamily(bold)
                              .size(18)
                              .make(),
                          10.heightBox,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                                future: FirestorServices.getFeaturedProduct(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: loadingIndicator(),
                                    );
                                  } else if (snapshot.data!.docs.isEmpty) {
                                    return "No Featured product"
                                        .text
                                        .white
                                        .make();
                                  } else {
                                    var featuredData = snapshot.data!.docs;
                                    return Row(
                                        children: List.generate(
                                            featuredData.length,
                                            (index) => Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Image.network(
                                                      featuredData[index]
                                                          ['p_imgs'][0],
                                                      width: 150,
                                                      height: 150,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    10.heightBox,
                                                    "${featuredData[index]['p_name']}"
                                                        .text
                                                        .fontFamily(semibold)
                                                        .color(darkFontGrey)
                                                        .make(),
                                                    10.heightBox,
                                                    "${featuredData[index]['p_price']}"
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
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4))
                                                    .padding(EdgeInsets.all(8))
                                                    .make()
                                                    .onTap(() {
                                                  Get.to(() => ItemDetails(
                                                      title:
                                                          "${featuredData[index]['p_name']}",
                                                      data:
                                                          featuredData[index]));
                                                })));
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                    10.heightBox,
                    // third swiper
                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: secondSliderList.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            secondSliderList[index],
                            fit: BoxFit.fill,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        }),
                    // all producsts section
                    20.heightBox,
                    StreamBuilder(
                        stream: FirestorServices.allProduct(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return loadingIndicator();
                          } else {
                            var allProductData = snapshot.data!.docs;
                            return GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: allProductData.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        mainAxisExtent: 300),
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        allProductData[index]['p_imgs'][0],
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                                      Spacer(),
                                      "${allProductData[index]['p_name']}"
                                          .text
                                          .fontFamily(semibold)
                                          .color(darkFontGrey)
                                          .make(),
                                      10.heightBox,
                                      "${allProductData[index]['p_price']}"
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
                                      .make()
                                      .onTap(() {
                                    Get.to(() => ItemDetails(
                                        title:
                                            "${allProductData[index]['p_name']}",
                                        data: allProductData[index]));
                                  });
                                });
                          }
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
