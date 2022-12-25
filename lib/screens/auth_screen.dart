import 'package:chat_app/main.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //For google signin
  GoogleSignIn googleSignIn = GoogleSignIn(); //google sign in instance
  FirebaseFirestore firestore =
      FirebaseFirestore.instance; //To store userdata firebase

  Future signInFunction() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      //If the user don't click signIN button and click back then the user will be returned
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken); //google sign IN authentication
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(
            credential); //this line of code used for access the account authentication and store the information

    DocumentSnapshot userExits =
        await firestore.collection("users").doc(userCredential.user!.uid).get();

    if (userExits.exists) {
      print("User Already Exits in Database");
    } else {
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        "email": userCredential.user!.email,
        "name": userCredential.user!.displayName,
        "Image": userCredential.user!.photoURL,
        "uid": userCredential.user!.uid,
        "date": DateTime.now(),
      });
    }
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://cdn-icons-png.flaticon.com/512/134/134909.png",
                  ),
                ),
              ),
            ),
          ),
          Text(
            "Flutter Chat App",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ElevatedButton(
              onPressed: () async {
                await signInFunction();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    "https://developers.google.com/static/identity/images/g-logo.png",
                    height: 36,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Sign in With Google",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 12))),
            ),
          )
        ],
      )),
    );
  }
}
