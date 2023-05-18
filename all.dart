import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mates_ui/base_client.dart';
import 'package:mates_ui/globals.dart';
import 'package:mates_ui/root_page.dart';
import 'package:mates_ui/widgets/email_field.dart';
import 'package:mates_ui/widgets/get_started_button.dart';
// import 'package:mates_ui/widgets/messages_screen.dart';
import 'package:mates_ui/widgets/password_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuddyUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;
  bool isVisible = false;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: loadingBallAppear
            ? const RootPage()
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween(begin: 1, end: _elementsOpacity),
                  builder: (_, value, __) => Opacity(
                    opacity: value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.flutter_dash,
                            size: 60, color: Color(0xff21579C)),
                        const SizedBox(height: 25),
                        const Text(
                          "Welcome,",
                          style: TextStyle(
                              color: Colors.black, fontSize: 35),
                        ),
                        Text(
                          "Log in to continue",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 35),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      EmailField(
                          fadeEmail: _elementsOpacity == 0,
                          emailController: emailController),
                      const SizedBox(height: 40),
                      PasswordField(
                          fadePassword: _elementsOpacity == 0,
                          passwordController: passwordController),
                      const SizedBox(height: 60),
                      Visibility(
                        visible: isVisible,
                        child: Text(
                          "Invalid Email or Password!",
                          style: TextStyle(
                              color: Colors.red.withOpacity(0.9),
                              fontSize: 20
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,15.0,0,0),
                        child: GetStartedButton(
                          elementsOpacity: _elementsOpacity,
                          onTap: () async {
                            var email = emailController;
                            var password = passwordController;
                            print(email.text);
                            print(password.text);
                            var payload = {
                              'email' : email.text,
                              'password' : password.text
                            };
                            setState(() {
                              _elementsOpacity = 0;
                            });
                          },
                          onAnimatinoEnd: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            var email = emailController;
                            var password = passwordController;
                            print(email.text);
                            print(password.text);
                            var payload = {
                              'email' : email.text,
                              'password' : password.text
                            };
                            var response = await BaseClient().post('/login',payload).catchError((err) {});

                            // var response = await BaseClient().get('/all_accounts').catchError((err) {});
                            print(response);
                            setState(() {
                              if (response != null){
                                userId = json.decode(response)['id'];
                                loadingBallAppear = true;
                                _elementsOpacity = 1;
                              }else {
                                _elementsOpacity = 1;
                                isVisible = true;
                                emailController.clear();
                                passwordController.clear();
                              }

                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:mates_ui/home_page.dart';
import 'package:mates_ui/account_page.dart';
import 'package:mates_ui/chat_page.dart';
import 'package:mates_ui/event_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = const [
    HomePage(),
    EventPage(),
    ChatPage(),
    AccountPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : const Text("BuddyUp"),
      ),
      body: pages[currentPage],
      // floatingActionButton: FloatingActionButton(onPressed: (){}),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.graphic_eq), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.event), label: 'Event'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.account_box), label: 'Account'),
        ],
        onDestinationSelected: (int index){
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mates_ui/base_client.dart';

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
    // BaseClient().get("/all_accounts");
    fetchUser();
  }

  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse("http://127.0.0.1:5000/all_accounts");
    var response = await http.get(url);
    print(response.statusCode);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'];
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
      // appBar: AppBar(
      //   title: Text("BuddyUp"),
      // ),
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
    print(item);
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
import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:5000';

class BaseClient {
  var client = http.Client();

  //GET
  Future<dynamic> get(String api) async {

    var url = Uri.parse(baseUrl + api);
    var response = await client.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }

  Future<dynamic> post(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    print(url);
    print(payload);
    var headers = {
      //   'Authorization': 'Bearer sfie328370428387=',
      'Content-Type': 'application/json',
      'Accept' : '*/*',
      'Accept-Encoding' : 'gzip, deflate, br',
      'Connection' : 'keep-alive'
      //   'api_key': 'ief873fj38uf38uf83u839898989',
    };

    var response = await client.post(url, body: payload, headers: headers);
    // var response = await client.post(url, body: payload);
    print('response');
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }

  ///PUT Request
  Future<dynamic> put(String api, dynamic object) async {
    var url = Uri.parse(baseUrl + api);
    var payload = json.encode(object);
    var headers = {
      'Authorization': 'Bearer sfie328370428387=',
      'Content-Type': 'application/json',
      'api_key': 'ief873fj38uf38uf83u839898989',
    };

    var response = await client.put(url, body: payload, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }

  Future<dynamic> delete(String api) async {
    var url = Uri.parse(baseUrl + api);
    var headers = {
      'Authorization': 'Bearer sfie328370428387=',
      'api_key': 'ief873fj38uf38uf83u839898989',
    };

    var response = await client.delete(url, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:mates_ui/base_client.dart';
import 'package:mates_ui/data/account_json.dart';
import 'package:mates_ui/globals.dart';
import 'package:mates_ui/styles/colors.dart';
import 'package:mates_ui/widgets/image_from_url.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  Map<String, dynamic> account = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAccount();
  }

  fetchAccount() async {
    setState(() {
      isLoading = true;
    });
    var response = await BaseClient().get("/account_details/$userId");
    if(response != null){
      var item = json.decode(response);
      print(item);
      setState(() {
        account = item;
        isLoading = false;
      });
    }else{
      account = {};
      isLoading = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.2),
      body: getBody(),
    );
  }

  Widget getBody() {
    var name = '';
    if (account['first_name'] != Null && account['last_name'] != Null){
      name = account['first_name'] + " " + account['last_name'];
    }
    var size = MediaQuery.of(context).size;
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        width: size.width,
        height: size.height * 0.60,
        decoration: BoxDecoration(color: white, boxShadow: [
          BoxShadow(
            color: grey.withOpacity(0.1),
            spreadRadius: 10,
            blurRadius: 10,
            // changes position of shadow
          ),
        ]),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 140,
                height: 140,
                child : ImageFromUrl(
                    imageUrl: account['profileUrl']?? " ",
                    width : 200,
                    height: 100
                ),
                // decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     image: DecorationImage(
                //         image: AssetImage(account['profileUrl']),
                //         fit: BoxFit.cover)
                //   ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(name,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: white,
                            boxShadow: [
                              BoxShadow(
                                color: grey.withOpacity(0.1),
                                spreadRadius: 10,
                                blurRadius: 15,
                                // changes position of shadow
                              ),
                            ]),
                        child: Icon(
                          Icons.settings,
                          size: 35,
                          color: grey.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "SETTINGS",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: grey.withOpacity(0.8)),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Container(
                          width: 85,
                          height: 85,
                          child: Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [primary_one, primary_two],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: grey.withOpacity(0.1),
                                        spreadRadius: 10,
                                        blurRadius: 15,
                                        // changes position of shadow
                                      ),
                                    ]),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 45,
                                  color: white,
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 0,
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: grey.withOpacity(0.1),
                                          spreadRadius: 10,
                                          blurRadius: 15,
                                          // changes position of shadow
                                        ),
                                      ]),
                                  child: const Center(
                                    child: Icon(Icons.add, color: primary),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "ADD MEDIA",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: grey.withOpacity(0.8)),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: white,
                            boxShadow: [
                              BoxShadow(
                                color: grey.withOpacity(0.1),
                                spreadRadius: 10,
                                blurRadius: 15,
                                // changes position of shadow
                              ),
                            ]),
                        child: Icon(
                          Icons.edit,
                          size: 35,
                          color: grey.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "EDIT INFO",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: grey.withOpacity(0.8)),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
