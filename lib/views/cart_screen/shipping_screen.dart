import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/views/cart_screen/payment_screen.dart';
import 'package:ecommerce_app/widget_common/our_button.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../widget_common/comon_textfield.dart';

class ShippingDetails extends StatelessWidget {
  var controller = Get.find<CartController>();

  ShippingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: "Shipping Info"
            .text
            .color(darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: OurButton(
            onPresss: () {
              if (controller.addressController.text.length > 10) {
                Get.to(() => PaymentScreen());
              } else {
                VxToast.show(context, msg: "Please fill the form");
              }
            },
            color: redColor,
            textColor: whiteColor,
            title: "Continue"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CustomTextField(
                hint: "Address",
                isPass: false,
                title: "Address",
                controller: controller.addressController),
            CustomTextField(
                hint: "City",
                isPass: false,
                title: "City",
                controller: controller.cityController),
            CustomTextField(
                hint: "State",
                isPass: false,
                title: "State",
                controller: controller.stateController),
            CustomTextField(
                hint: "Postal Code",
                isPass: false,
                title: "Postal",
                controller: controller.postalController),
            CustomTextField(
                hint: "Phone",
                isPass: false,
                title: "Phone",
                controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}
