import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthController extends GetxController {
  var emailControler = TextEditingController();
  var passControler = TextEditingController();
  var isloading = false.obs;
  // var signoutS=false.obs;

  Future<UserCredential?> loginMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      isloading(true);
      VxToast.show(context, msg: emailControler.text);
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailControler.text, password: passControler.text);
      isloading(false);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
      isloading(false);
    }
    return userCredential;
  }

  //signup method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  storeUserData({name, password, email}) async {
    User? currentUser1 = auth.currentUser;

    DocumentReference store =
        await firestore.collection(usersCollection).doc(currentUser1!.uid);
    print("....................new uid..........."+currentUser1!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'cart_count': "00",
      'wishlist_count': "00",
      'order_cart': "00",
      'id': currentUser1!.uid,
    });
  }
  //signOut method


}
