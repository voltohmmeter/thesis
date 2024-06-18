import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salinsalita/screens/home/components/speech_catch.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:salinsalita/Admin/admin_login.dart';
import 'package:salinsalita/pages/home.dart';
import 'package:salinsalita/screens/home/components/camera.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class SideMenu extends StatefulWidget {
  final String username;
  const SideMenu({Key? key, required this.username}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarX(
            controller: _controller,
            theme: SidebarXTheme(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              selectedTextStyle:
                  const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              itemTextPadding: const EdgeInsets.only(left: 30),
              selectedItemTextPadding: const EdgeInsets.only(left: 30),
              selectedItemDecoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
              iconTheme: const IconThemeData(
                color: Color.fromARGB(255, 0, 0, 0),
                size: 24,
              ),
              selectedIconTheme: const IconThemeData(
                color: Color.fromARGB(255, 0, 0, 0),
                size: 24,
              ),
            ),
            extendedTheme: SidebarXTheme(
              width: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            headerBuilder: (context, extended) {
              return SizedBox(
                height: 200,
                child: UserAccountsDrawerHeader(
                  accountName: Text(widget.username),
                  accountEmail: const Text('Username'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icons/user-icon.png',
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 0, 0, 0),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/Backgrounds/bggs.jpg'),
                    ),
                  ),
                ),
              );
            },
            items: [
              SidebarXItem(
                icon: Icons.home,
                label: 'Home',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              SidebarXItem(
                icon: Icons.sign_language,
                label: 'Realtime',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignLanguageRecognition(),
                    ),
                  );
                },
              ),
              SidebarXItem(
                icon: Icons.quiz,
                label: 'Quiz',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
              ),
              SidebarXItem(
                icon: Icons.notifications,
                label: 'Request',
              ),
              SidebarXItem(
                icon: Icons.settings,
                label: 'Settings',
                onTap: () => null,
              ),
              SidebarXItem(
                icon: Icons.admin_panel_settings,
                label: 'Admin',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Admin(),
                    ),
                  );
                },
              ),
              SidebarXItem(
                icon: Icons.exit_to_app,
                label: 'Exit',
                onTap: () {
                  _showExitDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showExitDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to exit the app?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
