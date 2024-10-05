import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/widget_common/our_button.dart';
import 'package:flutter/services.dart';

Widget exitDialog(context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.fontFamily(bold).color(darkFontGrey).size(18).make(),
        Divider(),
        10.heightBox,
        "Are you sure you want to exit"
            .text
            .size(16)
            .color(darkFontGrey)
            .make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OurButton(
                color: redColor,
                onPresss: () {
                  SystemNavigator.pop();
                },
                textColor: whiteColor,
                title: 'Yes'),
            OurButton(
                color: redColor,
                onPresss: () {
                  Navigator.pop(context);
                },
                textColor: whiteColor,
                title: 'No')
          ],
        )
      ],
    ).box.roundedSM.padding(EdgeInsets.all(12)).color(lightGrey).make(),
  );
}
