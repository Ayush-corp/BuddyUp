import 'package:flutter/material.dart';
import 'package:buddyup/widgets/home_page.dart';
import 'package:buddyup/widgets/account_page.dart';
import 'package:buddyup/widgets/chat_page.dart';
import 'package:buddyup/widgets/event_page.dart';

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


