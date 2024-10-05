import 'package:ecommerce_app/consts/consts.dart';
Widget DetailsCart({width,String? count,String? title}){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      count!.text.fontFamily(bold).color(darkFontGrey).size(16).make(),
      5.heightBox,
      title!.text.fontFamily(bold).color(darkFontGrey).make(),

    ],
  )
      .box
      .white
      .width(width)
      .rounded
      .padding(EdgeInsets.all(4)).height(60)
      .make();
}