import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:buddyup/controller/base_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List users = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser();
  }

  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    var response = await BaseClient().get("/all_accounts");
    if(response != null){
      var items = json.decode(response)['data'];
      print(items);
      setState(() {
        users = items;
        isLoading = false;
      });
    }else{
      users = [];
      isLoading = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : getBody(),
    );
  }
  Widget getBody(){
    // ignore: prefer_is_empty
    if(users.contains(null) || users.length < 0 || isLoading){
      return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),));
    }
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context,index){
          return getCard(users[index]);
        });
  }
  Widget getCard(item){
    var fullName = item['first_name']+" "+item['last_name'];
    var email = item['email'];
    var profileUrl = item['profileUrl'];
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(60/2),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(profileUrl)
                      )
                  ),
                ),
              ),
              const SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                      width: MediaQuery.of(context).size.width-140,
                      child: Text(fullName,style: const TextStyle(fontSize: 17),)),
                  const SizedBox(height: 10,),
                  Text(email.toString(),style: const TextStyle(color: Colors.grey),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
