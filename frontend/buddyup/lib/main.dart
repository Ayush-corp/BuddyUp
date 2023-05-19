import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:buddyup/controller/base_client.dart';
import 'package:buddyup/config/globals.dart';
import 'package:buddyup/widgets/root_page.dart';
import 'package:buddyup/widgets/email_field.dart';
import 'package:buddyup/widgets/get_started_button.dart';
import 'package:buddyup/widgets/password_field.dart';

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween(begin: 1, end: _elementsOpacity),
                  builder: (_, value, __) => Opacity(
                    opacity: value,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          './images/logo_sm.png',
                          width: 125, // Adjust the width as needed
                          height: 125, // Adjust the height as needed
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          "Welcome",
                          style: TextStyle(
                              color: Colors.black, fontSize: 35),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Log in to continue",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 20),
                          ),
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
                                print(userId);
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


