import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  UserModel user;
  SearchScreen(this.user); //to get the user

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult =
      []; //firbase data ar coming json or map formate// there are three user there will be three maps
  bool isloading = false;

  void onSearch() async {
    setState(() {
      searchResult = [];
      isloading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: searchController.text)
        .get()
        .then((value) {
      if (value.docs.length < 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No User Found"),
        ));
        setState(() {
          isloading = false;
        });

        return; //there is no user available return
      }
      value.docs.forEach((user) {
        if (user.data()['email'] != widget.user.email) {
          //it is for ignoring the real user to not search himself
          searchResult.add(user.data());
        }
      });
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search your friends."),
      ),
      body: Column(children: [
        Row(
          children: [
            Expanded(
              //takes all the space
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      hintText: "Type username...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
            IconButton(
                onPressed: (() {
                  onSearch();
                }),
                icon: Icon(Icons.search))
          ],
        ),
        if (searchResult.length > 0)
          Expanded(
              child: ListView.builder(
                  itemCount: searchResult.length,
                  shrinkWrap: true,
                  itemBuilder: (contex, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Image.network(
                          searchResult[index]['Image'],
                        ),
                      ),
                      title: Text(searchResult[index]['name']),
                      subtitle: Text(searchResult[index]['email']),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            searchController.text =
                                ""; // when he click back button he can click another user if he wants
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => ChatScreen(
                                  currentUser: widget.user,
                                  friendId: searchResult[index]['uid'],
                                  friendName: searchResult[index]['name'],
                                  friendImage: searchResult[index]['Image'])),
                            ),
                          );
                        },
                        icon: Icon(Icons.message),
                      ),
                    );
                  }))
        else if (isloading == true)
          Center(
            child: CircularProgressIndicator(),
          )
      ]),
    );
  }
}
