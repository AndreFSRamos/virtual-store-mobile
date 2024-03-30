import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtal_store/models/cart_model.dart';
import 'package:virtal_store/models/user_model.dart';
import 'package:virtal_store/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    UserModel userModel = UserModel();
    return ScopedModel<UserModel>(
        model: userModel,
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return ScopedModel<CartModel>(
                model: CartModel(model),
                child: MaterialApp(
                  theme: ThemeData(
                    primarySwatch: Colors.pink,
                    primaryColor: const Color.fromARGB(255, 214, 21, 125),
                  ),
                  //comando para retirar a TAG de modo debug.
                  debugShowCheckedModeBanner: false,
                  //chamando a a home page.
                  home: HomeScreen(),
                ));
          },
        ));
  }
}