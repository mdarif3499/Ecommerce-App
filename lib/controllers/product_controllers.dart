import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/categories_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../consts/consts.dart';
import '../consts/firebase_consts.dart';

class ProductController extends GetxController {
  var subcat = [];
  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;
  var isFav = false.obs;

  getSubCategory(title) async {
    var data = await rootBundle.loadString("lib/services/category_model.json");
    CategoryModel decoded = categoryModelFromJson(data);
    var s =
        decoded.categories.where((element) => element.name == title).toList();
    print(".....................${s.length}.....");
    subcat = [];

    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  changeColoreIndex(index) {
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

  decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  calculateTotalPrice(price) {
    totalPrice.value = price * quantity.value;
  }

  addToCard({title, img, sellerName, tprice, color, qty, context,vendorID}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? currentUser1 = auth.currentUser;
    if (qty == 0) {
      VxToast.show(context, msg: "Choose at-least one product to add to cart");
    } else {
      await firestore.collection("cart").doc().set({
        'title': title,
        'img': img,
        'sellername': sellerName,
        'color': color,
        'qty': qty,
        'vendor_id': vendorID,
        'tprice': tprice,
        'added_by': currentUser1!.uid
      }).catchError((error) {
        print("" + error.toString());
        VxToast.show(context, msg: error.toString());
      });
    }
  }

  resetValue() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  addToWishlist(docId,context) async {
    await firestore.collection(productCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to Wishlist");


  }

  removeWishlist(docId,context) async {
    await firestore.collection(productCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
     VxToast.show(context, msg: "Remove from Wishlist");
  }

  checkifFave( data) async {
    if(data['p_wishlist'].contains(currentUser!.uid)){
      isFav(true);
    }else{
      isFav(false);

    }
  }
}
