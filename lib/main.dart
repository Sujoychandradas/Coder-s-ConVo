import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //after creating the flutter projcet
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, //For the first error PlatformException (PlatformException(null-error, Host platform returned null value for non-null return value., null, null))
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

//This mehtod is used for checking if the user singed out or not
//If the user is not signed out still can asscess the app
  Future<Widget> UserSignedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      UserModel userModel =
          UserModel.fromJson(userData); //sending data in user Model
      return HomeScreen(userModel);
    } else {
      return AuthScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: AuthScreen(),
      home: FutureBuilder(
          future: UserSignedIn(),
          builder: (context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!; //it simply means return the widget
            }
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }),
      debugShowCheckedModeBanner: false,
      
    );
  }
}
