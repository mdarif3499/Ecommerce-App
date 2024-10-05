import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controllers/product_controllers.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/categoary_screen/item_details.dart';
import 'package:ecommerce_app/widget_common/bg_widget.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../consts/progressbar.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final String? title;

  const CategoryDetailsScreen({Key? key, this.title}) : super(key: key);

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {

  var controller = Get.find<ProductController>();
  dynamic productMethod;

  @override
  void initState() {
    super.initState();
    switchCategoary(widget.title);
  }

  switchCategoary(title) {
    if (controller.subcat.contains(title)) {
      productMethod = FirestorServices.getSubCategoaryProduct(title);
    }
    else {
      productMethod = FirestorServices.getProduct(title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
            appBar: AppBar(
              title: widget.title?.text
                  .fontFamily(bold)
                  .white
                  .make(),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(
                          controller.subcat.length,
                              (index) =>
                              "${controller.subcat[index]}"
                                  .text
                                  .size(12)
                                  .color(darkFontGrey)
                                  .fontFamily(semibold)
                                  .makeCentered()
                                  .box
                                  .rounded
                                  .white
                                  .size(120, 50)
                                  .margin(
                                  EdgeInsets.symmetric(horizontal: 4))
                                  .make()
                                  .onTap(() {
                                switchCategoary("${controller.subcat[index]}");
                                setState(() {

                                });
                              }))),
                ),
                20.heightBox,
                loadingIndicator(),
                StreamBuilder(
                    stream: productMethod,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Expanded(
                          child: Center(
                            child: loadingIndicator(),
                          ),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Expanded(
                          child:
                          "No products found!".text.color(darkFontGrey)
                              .makeCentered(),

                        );
                      } else {
                        var data = snapshot.data!.docs;
                        return
                          //item container
                          Expanded(
                              child: Container(
                                color: lightGrey,
                                child: GridView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: data.length,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 250,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            data[index]['p_imgs'][1],
                                            height: 180,
                                            width: 200,
                                            fit: BoxFit.cover,
                                          ),
                                          4.heightBox,
                                          "${widget.title}"
                                              .text
                                              .fontFamily(semibold)
                                              .color(darkFontGrey)
                                              .make(),
                                          2.heightBox,
                                          "${data[index]['p_price']}"
                                              .numCurrency
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
                                        controller.checkifFave(data[index]);
                                        Get.to(() =>
                                            ItemDetails(
                                              title: "${data[index]['p_name']}",
                                              data: data[index],));
                                      });
                                    }),
                              ))
                        ;
                      }
                    }),
              ],
            )));
  }
}
