import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/views/splash_screen/Splash_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDJXpsmp7eIFdrPMb86wjN9XFnj2nAqvQ4",
          appId: "1:397606951589:android:1b8ad47fb4a3960dc94b4c",
          messagingSenderId: "397606951589",
          projectId: "e-commerceapp-12d94",
          storageBucket   : "e-commerceapp-12d94.appspot.com"));



  runApp(const MyApp
  (
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: darkFontGrey),
            elevation: 0.0,
            backgroundColor: Colors.transparent),
        fontFamily: regular,
      ),
      home: const SplashScreen(),
    );
  }
}
